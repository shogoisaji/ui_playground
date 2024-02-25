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
    final h = MediaQuery.sizeOf(context).height;

    final _outerRadius = (w * 1.7) / 2;

    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      // appBar: AppBar(
      //   title: const Text('Interactive Selector'),
      // ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    bottom: 30,
                    child: Container(
                      width: w,
                      height: 200,
                      child: CustomPaint(
                        painter: SelectorPainter(
                            startAngle: math.pi * 0.35,
                            endAngle: math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle,
                            objectHeight: 120,
                            outerRadius: _outerRadius),
                      ),
                    ),
                  ),
                  Positioned(
                      top: -135 -
                          (_outerRadius - h) +
                          _outerRadius * math.sin(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle),
                      left: w / 2 -
                          50 +
                          ((w * 1.7) / 2 - 60) *
                              math.cos(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                        },
                        child: Opacity(
                          opacity: _animation.value.clamp(0, 1),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CustomPaint(
                              painter: ButtonPainter(),
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      top: -135 -
                          (_outerRadius - h) +
                          _outerRadius *
                              math.sin(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle * 2 / 3),
                      left: w / 2 -
                          50 +
                          ((w * 1.7) / 2 - 60) *
                              math.cos(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle * 2 / 3),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                        },
                        child: Opacity(
                          opacity: _animation.value.clamp(0, 1),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CustomPaint(
                              painter: ButtonPainter(),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      top: -135 -
                          (_outerRadius - h) +
                          _outerRadius * math.sin(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle / 3),
                      left: w / 2 -
                          50 +
                          ((w * 1.7) / 2 - 60) *
                              math.cos(math.pi * 0.35 + _animation.value.clamp(0, 1) * incrementAngle / 3),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                        },
                        child: Opacity(
                          opacity: _animation.value.clamp(0, 1),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CustomPaint(
                              painter: ButtonPainter(),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      top: -136 - (_outerRadius - h) + _outerRadius * math.sin(math.pi * 0.35),
                      left: w / 2 - 50 + ((w * 1.7) / 2 - 60) * math.cos(math.pi * 0.35),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                          } else {
                            _controller.forward();
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: ButtonPainter(),
                            child: Icon(
                              Icons.map,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      )),
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
    );
  }
}

class SelectorPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double objectHeight;
  final double outerRadius;
  SelectorPainter(
      {required this.startAngle, required double endAngle, required this.objectHeight, required this.outerRadius})
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
      // ..color = Colors.orange[500]!
      ..shader = LinearGradient(
        colors: [Colors.black, Colors.blueGrey[800]!, Colors.black],
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

    // var paintBg = Paint()
    //   ..color = Colors.orange[200]!
    //   ..style = PaintingStyle.fill;

    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBg);
    canvas.drawShadow(innerPath.shift(Offset(0, 3)), Colors.black.withOpacity(1.0), 3, false);
    canvas.drawPath(path, paint);
    canvas.drawShadow(innerPath.shift(Offset(0, -objectHeight / 5)), Colors.white.withOpacity(0.4), 15, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ButtonPainter extends CustomPainter {
  ButtonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    var rectOuter = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    var paint = Paint()
      // ..color = Colors.orange[500]!
      ..color = Colors.black.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    Path path = Path();

    path..addOval(rectOuter);

    // canvas.drawRect(rectOuter, paintBg);
    canvas.drawShadow(path.shift(Offset(0, -2)), Colors.white.withOpacity(0.9), 3, false);
    canvas.drawPath(path, paint);
    canvas.drawShadow(path.shift(Offset(0, -25)), Colors.white.withOpacity(0.7), 20, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
