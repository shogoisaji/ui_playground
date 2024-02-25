import 'package:flutter/material.dart';
import 'dart:math' as math;

class InteractiveSelector extends StatefulWidget {
  const InteractiveSelector({super.key});

  @override
  State<InteractiveSelector> createState() => _InteractiveSelectorState();
}

class _InteractiveSelectorState extends State<InteractiveSelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double incrementAngle = 0.0;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Selector'),
      ),
      body: Center(
        child: Container(
          color: Colors.green[100],
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: w,
                  height: w,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: SelectorPainter(
                            startAngle: math.pi * 0.35,
                            endAngle: math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle,
                            objectHeight: 80,
                            radius: (w * 1.7) / 2),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.isCompleted) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                  child: const Text('Animate'),
                ),
              ),
              Align(
                  alignment: Alignment(0, -0.3),
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: Slider(
                            min: 0,
                            max: math.pi * 0.35,
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
        ),
      ),
    );
  }
}

class SelectorPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double objectHeight;
  final double radius;
  SelectorPainter(
      {required this.startAngle, required double endAngle, required this.objectHeight, required this.radius})
      : endAngle = endAngle >= startAngle ? endAngle : throw ArgumentError('endAngle must be greater than startAngle');

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = radius;
    final innerRadius = outerRadius - objectHeight;
    final Offset offsetCenter = Offset(size.width / 2, outerRadius / 2 - size.width / 2);

    Offset calculateOffset(double angle, double radius) {
      double x = radius * math.cos(angle);
      double y = radius * math.sin(angle);
      return Offset(x, y);
    }

    var paint = Paint()
      ..color = Colors.orange[500]!
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    var paintBg = Paint()
      ..color = Colors.orange[100]!
      ..style = PaintingStyle.fill;
    var paintBg2 = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    // canvas.translate(size.width / 2, outerRadius / 2);

    Path path = Path();

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

    path
      ..arcTo(rectOuter, startAngle, endAngle - startAngle, true)
      ..arcTo(rectLeft, endAngle, math.pi, true)
      ..arcTo(rectInner, endAngle, -(endAngle - startAngle), false)
      ..arcTo(rectRight, startAngle - math.pi, math.pi, false);

    canvas.drawRect(rectOuter, paintBg);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
