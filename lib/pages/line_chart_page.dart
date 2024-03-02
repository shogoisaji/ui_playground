import 'package:flutter/material.dart';

import 'dart:math' as math;

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  static const List<String> _labels = ['12', '13', '14', '15', '16', '17', '18']; // 下のラベル
  static const intervalValueList = [5.0, 10.0, 20.0]; // グリッドの間隔の種類
  List<double> _values = [];
  double gridInterval = 10.0;
  double _maxValue = 0.0; // _valuesの最大値の切り上げたインターバル値
  double _minValue = 0.0; // _valuesの最小値の切り下げたインターバル値

  void initValue() {
    _values = [13, 23, 23, 20, 32, 15, 30];
    _maxValue = ((_values.reduce(math.max) ~/ gridInterval) + 1) * gridInterval;
    _minValue = (_values.reduce(math.min) ~/ gridInterval) * gridInterval;
  }

  void shuffleValue() {
    final random = math.Random();
    for (int i = 0; i < _values.length; i++) {
      _values[i] = random.nextInt(50).toDouble();
    }
    setState(() {
      _maxValue = ((_values.reduce(math.max) ~/ gridInterval) + 1) * gridInterval;
      _minValue = (_values.reduce(math.min) ~/ gridInterval) * gridInterval;
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 300,
            child: CustomPaint(
              painter: LineChartPainter(
                  labels: _labels,
                  values: _values,
                  maxValue: _maxValue,
                  minValue: _minValue,
                  gridInterval: gridInterval),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'values : ${_values.map((e) => e.toStringAsFixed(0)).join(', ')}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                shuffleValue();
              },
              child: const Text('Shuffle')),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: intervalValueList.map((interval) {
                return Expanded(
                  child: ListTile(
                    title: Text(interval.toStringAsFixed(0)),
                    leading: Radio<double>(
                      value: interval.toDouble(),
                      groupValue: gridInterval,
                      onChanged: (double? value) {
                        setState(() {
                          gridInterval = value!;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    ));
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> labels; // 下のラベル
  final List<double> values; //各ラベルの値
  final double maxValue; // _valuesの最大値の切り上げたインターバル値
  final double minValue; // _valuesの最小値の切り下げたインターバル値
  final double gridInterval;
  LineChartPainter({
    required this.labels,
    required this.values,
    required this.maxValue,
    required this.minValue,
    required this.gridInterval,
  });

  static const double upperAreaHeight = 50;
  static const double lowerAreaHeight = 50;
  static const double leftAreaWidth = 50;
  static const double rightAreaWidth = 30;

  static Color bgColor = Colors.grey.shade900;
  static Color lineColor = Colors.green.shade500;
  static Color baseLineColor = Colors.green.shade300;
  static Color gridColor = Colors.green.shade100;
  static Color textColor = Colors.grey;

  @override
  void paint(Canvas canvas, Size size) {
    final clipRect = Rect.fromLTWH(0, 0, size.width, size.height);

    /// 背景描画
    canvas.clipRect(clipRect); // 描画領域を制限
    canvas.drawPaint(Paint()..color = bgColor);

    final valueAreaHeight = size.height - upperAreaHeight - lowerAreaHeight;
    final valueAreaWidth = (size.width - leftAreaWidth - rightAreaWidth) / labels.length;
    final baseLineHeight = size.height - lowerAreaHeight;
    final points = _createPoint(valueAreaHeight, valueAreaWidth);

    _drawLowerLabelTextPainter(canvas, size); // lowerArea
    _drawLeftLabelTextPainter(canvas, size, valueAreaHeight, baseLineHeight); // leftArea
    _drawBaseLine(canvas, size, baseLineHeight);
    _drawIntervalLine(canvas, size, valueAreaHeight, baseLineHeight);
    _drawLine(canvas, points);
    _drawPoint(canvas, points);
  }

  List<Offset> _createPoint(double valueAreaHeight, double valueAreaWidth) {
    final List<Offset> points = [];
    for (int i = 0; i < labels.length; i++) {
      final x = leftAreaWidth + valueAreaWidth * (i) + valueAreaWidth / 2;
      final y = upperAreaHeight + valueAreaHeight - (valueAreaHeight / (maxValue - minValue) * (values[i] - minValue));
      points.add(Offset(x, y));
    }
    return points;
  }

  List<LeftLabel> _intervalHeightList(double valueAreaHeight, double baseLineHeight) {
    final List<LeftLabel> intervalHeightList = [];
    final intervalCount = (maxValue ~/ gridInterval) - (minValue ~/ gridInterval);
    for (int i = 0; i < intervalCount; i++) {
      final labelValue = minValue + gridInterval * (i + 1);
      final height = baseLineHeight - valueAreaHeight / (maxValue - minValue) * (labelValue - minValue);
      intervalHeightList.add(LeftLabel(labelValue.toString(), height));
    }
    return intervalHeightList;
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    final Paint paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawPoint(Canvas canvas, List<Offset> points) {
    final fillPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final point in points) {
      canvas.drawCircle(point, 5, fillPaint);
      canvas.drawCircle(point, 5, strokePaint);
    }
  }

  void _drawBaseLine(Canvas canvas, Size size, double baseLineHeight) {
    final Paint paint = Paint()
      ..color = baseLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(leftAreaWidth, baseLineHeight)
      ..lineTo(size.width - rightAreaWidth, baseLineHeight);
    canvas.drawPath(path, paint);
  }

  void _drawIntervalLine(Canvas canvas, Size size, double valueAreaHeight, double baseLineHeight) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final Paint paint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final List<LeftLabel> intervalList = _intervalHeightList(valueAreaHeight, baseLineHeight);
    for (int i = 0; i < intervalList.length; i++) {
      final path = Path();
      double startX = leftAreaWidth;

      /// 破線の描画
      while (startX < size.width - rightAreaWidth) {
        path.moveTo(startX, intervalList[i].height);
        startX += dashWidth;
        path.lineTo(startX, intervalList[i].height);
        startX += dashSpace;
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawLowerLabelTextPainter(Canvas canvas, Size size) {
    const paddingTop = 10;
    for (int i = 0; i < labels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              leftAreaWidth +
                  (i + 0.5) * (size.width - leftAreaWidth - rightAreaWidth) / labels.length -
                  textPainter.width / 2,
              size.height - lowerAreaHeight + paddingTop));
    }
  }

  void _drawLeftLabelTextPainter(Canvas canvas, Size size, double valueAreaHeight, double baseLineHeight) {
    final intervalList = _intervalHeightList(valueAreaHeight, baseLineHeight);
    const paddingRight = 10;
    for (int i = 0; i < intervalList.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: intervalList[i].label.split('.')[0],
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
            leftAreaWidth - textPainter.width - paddingRight,
            intervalList[i].height - textPainter.height / 2,
          ));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LeftLabel {
  final String label;
  final double height;
  LeftLabel(this.label, this.height);
}
