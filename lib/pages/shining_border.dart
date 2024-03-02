import 'package:flutter/material.dart';

class ShiningBorderPage extends StatelessWidget {
  const ShiningBorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color _shadowColor = Colors.green.shade400;
    final Color _borderColor = Colors.green.shade100;

    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShiningContainer(
                  width: 400,
                  height: 150,
                  outerColor: _shadowColor,
                  borderColor: _borderColor,
                  innerColor: Colors.grey.shade900,
                  radius: 24,
                  thickness: 4,
                  child: const Center(
                    child: Text('Container',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  )),
              SizedBox(
                width: 400,
                height: 150,
                child: CustomPaint(
                    painter: ShiningBorderPainter(
                        outerColor: _shadowColor,
                        borderColor: _borderColor,
                        innerColor: Colors.grey.shade900,
                        radius: 24,
                        thickness: 4),
                    child: const Center(
                      child: Text('CustomPaint',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    )),
              )
            ],
          ),
        ));
  }
}

class ShiningContainer extends StatelessWidget {
  final Color borderColor;
  final Color outerColor;
  final Color innerColor;
  final double radius;
  final double thickness;
  final Widget child;
  final double? width;
  final double? height;

  const ShiningContainer({
    Key? key,
    required this.borderColor,
    required this.outerColor,
    required this.innerColor,
    required this.radius,
    required this.thickness,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: thickness),
        color: outerColor,
        boxShadow: [
          BoxShadow(
            color: outerColor,
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius - thickness),
            color: innerColor,
            boxShadow: [
              BoxShadow(
                color: innerColor,
                spreadRadius: 7,
                blurRadius: 7,
              ),
            ],
          ),
          child: child),
    );
  }
}

class ShiningBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color outerColor;
  final Color innerColor;
  final double radius;
  final double thickness;
  ShiningBorderPainter(
      {required this.borderColor,
      required this.outerColor,
      required this.innerColor,
      required this.radius,
      required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final shadowWidth = thickness / 1.5;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    final outerPaint = Paint()
      ..color = outerColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    final innerPaint = Paint()
      ..color = innerColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    final RRect outerRect = RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(radius));
    final RRect borderRect = RRect.fromLTRBR(
        shadowWidth, shadowWidth, size.width - shadowWidth, size.height - shadowWidth, Radius.circular(radius));
    final RRect innerRect = RRect.fromLTRBR(shadowWidth * 2, shadowWidth * 2, size.width - shadowWidth * 2,
        size.height - shadowWidth * 2, Radius.circular(radius));

    canvas.drawRRect(outerRect, outerPaint);
    canvas.drawRRect(innerRect, innerPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
