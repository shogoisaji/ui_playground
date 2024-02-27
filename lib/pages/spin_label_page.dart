import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'dart:ui' as ui;

class SpinLabelPage extends StatefulWidget {
  const SpinLabelPage({super.key});

  @override
  State<SpinLabelPage> createState() => _SpinLabelPageState();
}

class _SpinLabelPageState extends State<SpinLabelPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _spinAnimation;
  late Animation<double> _scaleAnimation;
  double rotateY = 0.0;
  bool _isFront = true;
  bool _isShow = false;
  late Matrix4 matrix;
  late double convertedThickness;

  static const double _THICKNESS = 30;
  static const _LABEL_SIZE = 100.0;

  final GlobalKey _imageKey = GlobalKey(); // account image のpositionを取得するためのkey
  Offset _imagePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _spinAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
      reverseCurve: Curves.easeOutExpo,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
      reverseCurve: Curves.easeOutExpo,
    );

    _controller.addListener(() {
      setState(() {
        rotateY = _spinAnimation.value * 1 * math.pi;
        convertedThickness = math.sin(rotateY) * _THICKNESS;

        if (((rotateY + math.pi / 2) ~/ math.pi).isEven) {
          _isFront = true;
        } else {
          _isFront = false;
        }
      });
    });
    convertedThickness = math.sin(rotateY) * _THICKNESS;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_imageKey.currentContext == null) return;
      final RenderBox renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      setState(() {
        _imagePosition = position;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    matrix = ((rotateY + math.pi / 2) ~/ (math.pi)).isEven
        ? (Matrix4.identity()..rotateY(rotateY))
        : (Matrix4.identity()..rotateY(rotateY + math.pi));

    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SamplePage(
              imageKey: _imageKey,
              isImageShow: _isShow,
            ),
            Positioned(
              top: -_LABEL_SIZE / 2 -
                  9 -
                  AppBar().preferredSize.height +
                  _imagePosition.dy * (1 + _scaleAnimation.value),
              left: _LABEL_SIZE / 2 + _imagePosition.dx - (_LABEL_SIZE + _THICKNESS) / 2 + _scaleAnimation.value * 120,
              child: Transform.scale(
                scale: 1 + _scaleAnimation.value * 2,
                child: Opacity(
                  opacity: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 50,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    width: _LABEL_SIZE + _THICKNESS + 5,
                    height: _LABEL_SIZE + 5,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -_LABEL_SIZE / 2 -
                  9 -
                  AppBar().preferredSize.height +
                  _imagePosition.dy * (1 + _scaleAnimation.value),
              left: _LABEL_SIZE / 2 + _imagePosition.dx - (_LABEL_SIZE + _THICKNESS) / 2 + _scaleAnimation.value * 120,
              child: Transform.scale(
                scale: 1 + _scaleAnimation.value * 2,
                child: Container(
                  // color: Colors.red[800],
                  width: _LABEL_SIZE + _THICKNESS,
                  height: _LABEL_SIZE,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: -convertedThickness / 2 + _LABEL_SIZE / 2 + _THICKNESS / 2,
                        child: SizedBox(
                          width: _LABEL_SIZE + _THICKNESS,
                          height: _LABEL_SIZE,
                          child: CustomPaint(
                            painter: LabelSidePainter(
                                color: Color.fromARGB(255, 171, 87, 87),
                                rotate: rotateY,
                                thickness: convertedThickness,
                                radius: _LABEL_SIZE / 2),
                          ),
                        ),
                      ),
                      Positioned(
                        left: _isFront
                            ? -_LABEL_SIZE / 2 - convertedThickness / 2 + _LABEL_SIZE / 2 + _THICKNESS / 2
                            : -_LABEL_SIZE / 2 + convertedThickness / 2 + _LABEL_SIZE / 2 + _THICKNESS / 2,
                        child: GestureDetector(
                          onTap: () {
                            if (_controller.isCompleted) {
                              _controller.reverse(from: 0.4);
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                setState(() {
                                  _isShow = false;
                                });
                              });
                            } else {
                              _controller.forward();
                              setState(() {
                                _isShow = true;
                              });
                            }
                          },
                          child: Transform(
                            transform: matrix,
                            alignment: Alignment.center,
                            child: _isFront
                                ? Container(
                                    width: _LABEL_SIZE,
                                    height: _LABEL_SIZE,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/person.png',
                                    ),
                                  )
                                : Container(
                                    width: _LABEL_SIZE,
                                    height: _LABEL_SIZE,
                                    decoration: BoxDecoration(
                                      color: Colors.red[400]!,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Mark\nAndre',
                                            style: TextStyle(
                                                height: 1.0,
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Tel:123-456-7890',
                                            style: TextStyle(
                                                fontSize: 9.0, color: Colors.white, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelSidePainter extends CustomPainter {
  final double rotate;
  final double thickness;
  final Color color;
  final double radius;
  LabelSidePainter({required this.rotate, required this.color, required this.thickness, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final convertedWidth = (rotate ~/ math.pi).isEven ? math.cos(rotate) * radius : math.cos(rotate - math.pi) * radius;
    Offset p1 = Offset(thickness, 0);

    Offset p2 = Offset(thickness + convertedWidth / 1.7, 0);
    Offset p3 = Offset(thickness + convertedWidth, radius / 2);
    Offset p4 = Offset(thickness + convertedWidth, radius);

    Offset p5 = Offset(thickness + convertedWidth, radius * 3 / 2);
    Offset p6 = Offset(thickness + convertedWidth / 1.7, radius * 2);
    Offset p7 = Offset(thickness, radius * 2);

    Offset p8 = Offset(0, radius * 2);

    Offset p9 = Offset(convertedWidth / 1.7, radius * 2);
    Offset p10 = Offset(convertedWidth, radius * 3 / 2);
    Offset p11 = Offset(convertedWidth, radius);

    Offset p12 = Offset(convertedWidth, radius / 2);
    Offset p13 = Offset(convertedWidth / 1.7, 0);
    Offset p14 = Offset(0, 0);

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    Path path = Path();

    path
      ..lineTo(p1.dx, p1.dy)
      ..cubicTo(p2.dx, p2.dy, p3.dx, p3.dy, p4.dx, p4.dy)
      ..cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy)
      ..lineTo(p8.dx, p8.dy)
      ..cubicTo(p9.dx, p9.dy, p10.dx, p10.dy, p11.dx, p11.dy)
      ..cubicTo(p12.dx, p12.dy, p13.dx, p13.dy, p14.dx, p14.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SamplePage extends StatefulWidget {
  final GlobalKey imageKey;
  final bool isImageShow;
  const SamplePage({super.key, required this.imageKey, required this.isImageShow});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(-0.5, -0.6),
                            radius: 2.5,
                            colors: [
                              Colors.blueGrey.withOpacity(0.6),
                              Colors.grey.withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: !widget.isImageShow
                                        ? Image.asset(
                                            key: widget.imageKey,
                                            'assets/images/person.png',
                                          )
                                        : Container(),
                                  ),
                                  const Text(
                                    'Mark',
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Status',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 40.0),
                                        child: Text(
                                          '👍',
                                          style: TextStyle(
                                            fontSize: 60,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            width: w * 0.3,
                            height: h * 0.25,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(-0.5, -0.6),
                                radius: 2.5,
                                colors: [
                                  Colors.blueGrey.withOpacity(0.6),
                                  Colors.grey.withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                            ),
                            child: InkWell(
                              onTap: () {
                                print('tapped');
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.orange[300],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.home,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              width: w * 0.3,
                              height: h * 0.25,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment(-0.5, -0.6),
                                  radius: 2.5,
                                  colors: [
                                    Colors.blueGrey.withOpacity(0.6),
                                    Colors.grey.withOpacity(0.5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'History',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 24.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '2024/12/1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '2024/12/11',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '2024/12/21',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: double.infinity,
                        height: h * 0.2,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(-0.5, -0.6),
                            radius: 2.5,
                            colors: [
                              Colors.blueGrey.withOpacity(0.6),
                              Colors.grey.withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: w * 0.25,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: w * 0.25,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: w * 0.25,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red[300],
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600],
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
