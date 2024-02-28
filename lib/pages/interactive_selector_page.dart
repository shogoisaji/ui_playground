import 'package:flutter/material.dart';
import 'dart:math' as math;

class InteractiveSelector extends StatefulWidget {
  const InteractiveSelector({super.key});

  @override
  State<InteractiveSelector> createState() => _InteractiveSelectorState();
}

class _InteractiveSelectorState extends State<InteractiveSelector> with SingleTickerProviderStateMixin {
  static const _BUTTON_SIZE = 90.0; // buttonのサイズ
  static const _BOTTOM_PADDING = 150.0; // selector 全体のbottom padding
  static const _OBJECT_HEIGHT = 120.0; // selectorの高さ
  static const _START_ANGLE = math.pi * -0.25; // selectorの開始角度
  static const _END_ANGLE = math.pi * 1.95; // selectorの終了角度
  late AnimationController _controller;
  late Animation<double> _animation;
  double incrementAngle = 1.0;

  final items = [
    {
      'icon': Icons.map,
      'route': 'map',
    },
    {
      'icon': Icons.camera_alt,
      'route': 'camera',
    },
    {
      'icon': Icons.alarm,
      'route': 'alarm',
    },
    {
      'icon': Icons.history,
      'route': 'history',
    },
    {
      'icon': Icons.train,
      'route': 'train',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    final _outerRadius = (w * 0.4) / 2; // selectorの外径
    final _buttonRadius = _outerRadius - _OBJECT_HEIGHT / 2; // button位置の半径

    final Color _baseColor1 = Colors.orange[600]!;
    final Color _baseColor2 = Colors.orange[900]!;
    final Color _buttonColor = Colors.red[900]!;

    // Positioned buttonのtop位置を計算
    double calculateTopPosition(int index) {
      final _position = -_BOTTOM_PADDING -
          _BUTTON_SIZE / 2 -
          (_outerRadius - h) +
          _buttonRadius *
              math.sin(_START_ANGLE + _animation.value.clamp(0, 1) * incrementAngle * index / (items.length - 1));
      return _position;
    }

    // Positioned buttonのleft位置を計算
    double calculateLeftPosition(int index) {
      final _position = w / 2 -
          _BUTTON_SIZE / 2 +
          _buttonRadius *
              math.cos(_START_ANGLE + _animation.value.clamp(0, 1) * incrementAngle * index / (items.length - 1));
      return _position;
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // title: const Text('Interactive Selector'),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: h - _BOTTOM_PADDING,
                    // bottom: 0,
                    child: Container(
                      width: w,
                      height: 0,
                      child: CustomPaint(
                        painter: SelectorPainter(
                          startAngle: _START_ANGLE,
                          endAngle: _START_ANGLE + _animation.value.clamp(0, 1) * incrementAngle,
                          objectHeight: _OBJECT_HEIGHT,
                          outerRadius: _outerRadius,
                          color1: _baseColor1,
                          color2: _baseColor2,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(items.length, (index) {
                    final reversedIndex = items.length - 1 - index;
                    return Positioned(
                        top: calculateTopPosition(reversedIndex),
                        left: calculateLeftPosition(reversedIndex),
                        child: GestureDetector(
                          onTap: () {
                            if (reversedIndex == 0) {
                              if (_controller.isCompleted) {
                                _controller.reverse();
                              } else {
                                _controller.forward();
                              }
                            }
                            print('route: ${items[reversedIndex]['route']}'); // navigationなど
                          },
                          child: Opacity(
                            opacity: reversedIndex == 0 ? 1 : _animation.value.clamp(0, 1),
                            child: SizedBox(
                              width: _BUTTON_SIZE,
                              height: _BUTTON_SIZE,
                              child: CustomPaint(
                                painter: ButtonPainter(color: _buttonColor),
                                child: Icon(
                                  items[reversedIndex]['icon'] as IconData,
                                  color: Colors.white,
                                  size: _BUTTON_SIZE / 2,
                                ),
                              ),
                            ),
                          ),
                        ));
                  }),
                ],
              );
            },
          ),
          Align(
              alignment: Alignment(0, -0.3),
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: Slider(
                        min: 0,
                        max: _END_ANGLE,
                        value: incrementAngle,
                        onChanged: (value) {
                          setState(() {
                            incrementAngle = value;
                          });
                        },
                      ),
                    ),
                    Text('Angle: ${incrementAngle.toStringAsFixed(2)}'),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class SelectorPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double objectHeight;
  final double outerRadius;
  final Color color1;
  final Color color2;
  SelectorPainter(
      {required this.startAngle,
      required double endAngle,
      required this.objectHeight,
      required this.outerRadius,
      required this.color1,
      required this.color2})
      : endAngle = endAngle >= startAngle ? endAngle : throw ArgumentError('endAngle must be greater than startAngle');

  final GlobalKey buttonKey = GlobalKey();

  @override
  void paint(Canvas canvas, Size size) {
    final innerRadius = outerRadius - objectHeight;
    final Offset offsetCenter = Offset(size.width / 2, -(outerRadius - size.height));

    Offset calculateOffset(double angle, double radius) {
      double x = radius * math.cos(angle);
      double y = radius * math.sin(angle);
      return Offset(x, y);
    }

    var rectOuter = Rect.fromCenter(
      center: offsetCenter,
      width: outerRadius * 2,
      height: outerRadius * 2,
    );
    var rectInner = Rect.fromCenter(
      center: offsetCenter,
      width: innerRadius * 2,
      height: innerRadius * 2,
    );
    var rectLeft = Rect.fromCenter(
      center: offsetCenter + calculateOffset(endAngle, (outerRadius * 2 - (outerRadius - innerRadius)) / 2),
      width: (outerRadius - innerRadius),
      height: (outerRadius - innerRadius),
    );
    var rectRight = Rect.fromCenter(
      center: offsetCenter + calculateOffset(startAngle, (outerRadius * 2 - (outerRadius - innerRadius)) / 2),
      width: (outerRadius - innerRadius),
      height: (outerRadius - innerRadius),
    );

    var paint = Paint()
      ..shader = LinearGradient(
        colors: [color2, color1, color2],
      ).createShader(rectOuter)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    Path path = Path();
    Path innerPath = Path();

    path
      ..arcTo(rectOuter, startAngle, endAngle - startAngle, true)
      ..arcTo(rectLeft, endAngle, math.pi, true)
      ..arcTo(rectInner, endAngle, -(endAngle - startAngle), false)
      ..arcTo(rectRight, startAngle - math.pi, math.pi, false);

    innerPath
      ..arcTo(rectOuter, startAngle, endAngle - startAngle, true)
      ..arcTo(rectLeft, endAngle, math.pi, true)
      ..arcTo(rectInner, endAngle, -(endAngle - startAngle), false)
      ..arcTo(rectRight, startAngle - math.pi, math.pi, false);

    canvas.drawShadow(innerPath.shift(Offset(0, 3)), Colors.black.withOpacity(1.0), 3, false);
    canvas.drawPath(path, paint);
    canvas.drawShadow(innerPath.shift(Offset(0, -objectHeight / 5)), Colors.white.withOpacity(0.4), 15, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ButtonPainter extends CustomPainter {
  final Color color;
  ButtonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var rectOuter = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    Path path = Path();

    path.addOval(rectOuter);

    canvas.drawShadow(path.shift(Offset(0, -2)), Colors.white.withOpacity(0.9), 3, false);
    canvas.drawPath(path, paint);
    canvas.drawShadow(path.shift(Offset(0, -25)), Colors.white.withOpacity(0.7), 20, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
