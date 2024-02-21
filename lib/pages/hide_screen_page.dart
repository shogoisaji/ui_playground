import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideScreenPage extends StatefulWidget {
  const HideScreenPage({super.key});

  @override
  State<HideScreenPage> createState() => _HideScreenPageState();
}

class _HideScreenPageState extends State<HideScreenPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  AnimationController? _spinController;
  late Animation<double> _spinAnimation;
  late Animation<double> _animation;
  Offset _offset = const Offset(170.0, 200.0);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
    _spinController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOutBack,
    );
    _spinAnimation = CurvedAnimation(
      parent: _spinController!,
      curve: const Interval(0.0, 1.0, curve: Cubic(0.1, 0.5, 0.5, 0.5)),
    );
    _spinController!.addListener(() {
      setState(() {
        _offset =
            Offset(80 * cos(_spinAnimation.value * 2 * pi) + 150, 100 * sin(_spinController!.value * 2 * pi) + 180);
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _spinController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hide'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/elephant.jpg',
              fit: BoxFit.fill,
              // width: double.infinity,
              // height: double.infinity,
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: HideCustomPainter(animateValue: 1 - _animation.value, offset: _offset),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _offset += details.delta;
                });
              },
              child: Container(
                // width: double.infinity,
                // height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            !_controller!.isCompleted
                ? Align(
                    alignment: const Alignment(0, 0.9),
                    child: ElevatedButton(
                        onPressed: () {
                          _controller!.forward();
                        },
                        child: const Text('reverse')))
                : Container(),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0.0, 0.85 + 2 * (1 - _animation!.value)),
                  child: Opacity(
                    opacity: _controller!.value,
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                          const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                            onPressed: () {
                              if (_controller!.isCompleted) {
                                _controller!.reverse();
                              } else {
                                _controller!.forward();
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}

class HideCustomPainter extends CustomPainter {
  HideCustomPainter({required this.animateValue, required this.offset});

  final Offset offset;
  final double animateValue; // アニメーションの値

  @override
  void paint(Canvas canvas, Size size) {
    final double x1 = offset.dx + 200 * animateValue;
    final double y1 = offset.dy - (offset.dy + 200) * animateValue;
    final double x2 = offset.dx - 100 - 200 * animateValue;
    final double y2 = offset.dy + 120 + (size.height - offset.dy) * animateValue;

    Paint strokePaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.lineTo(0, y1);
    path1.lineTo(40 + x1, y1);
    path1.arcToPoint(
      Offset(80 + x1, 40 + y1),
      radius: const Radius.circular(40),
    );
    path1.lineTo(80 + x1, 80 + y1);
    path1.arcToPoint(
      Offset(120 + x1, 120 + y1),
      radius: const Radius.circular(40),
      clockwise: false,
    );
    path1.lineTo(size.width, 120 + y1);
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    Path path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, y2);
    path2.lineTo(40 + x2, y2);
    path2.arcToPoint(
      Offset(80 + x2, 40 + y2),
      radius: const Radius.circular(40),
    );
    path2.lineTo(80 + x2, 80 + y2);
    path2.arcToPoint(
      Offset(120 + x2, 120 + y2),
      radius: const Radius.circular(40),
      clockwise: false,
    );
    path2.lineTo(size.width, 120 + y2);
    path2.lineTo(size.width, size.height);
    path2.lineTo(size.width, size.height);
    path2.close();

    final shadowPaint = Paint()
      ..color = Colors.black // 影の色を設定
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0); // ぼかしの程度を設定

    canvas.drawPath(path1.shift(Offset(0.0, 0.0)), shadowPaint);

    canvas.drawPath(path1.shift(Offset(0.0, 0.0)), strokePaint); // キャンバスに描画
    canvas.drawPath(path1.shift(Offset(0.0, 0.0)), fillPaint); // キャンバスに描画

    canvas.drawPath(path2.shift(Offset(0.0, 0.0)), shadowPaint);

    canvas.drawPath(path2.shift(Offset(0.0, 0.0)), strokePaint); // キャンバスに描画
    canvas.drawPath(path2.shift(Offset(0.0, 0.0)), fillPaint); // キャンバスに描画
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
