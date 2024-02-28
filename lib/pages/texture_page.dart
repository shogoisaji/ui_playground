import 'dart:math';

import 'package:flutter/material.dart';

class TexturePage extends StatefulWidget {
  const TexturePage({super.key});

  @override
  State<TexturePage> createState() => _TexturePageState();
}

class _TexturePageState extends State<TexturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texture'),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const Center(
            child:
                Text('Hello World', style: TextStyle(color: Colors.grey, fontSize: 80, fontWeight: FontWeight.bold))),
        CustomPaint(
          painter: RoughTexture(),
        ),
      ]),
    );
  }
}

class RoughTexture extends CustomPainter {
  RoughTexture();

  @override
  void paint(Canvas canvas, Size size) {
    var rand = Random();

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 0.1;

    var path = Path();
    var path2 = Path();

    for (var i = 0; i < 5000; ++i) {
      var x1 = rand.nextDouble() * size.width - 500;
      var y1 = rand.nextDouble() * size.height - 100;
      var x2 = rand.nextDouble() * size.width + 500;
      var y2 = rand.nextDouble() * size.height + 300;
      var x3 = rand.nextDouble() * size.width - 200;
      var y3 = rand.nextDouble() * size.height + 300;

      path.moveTo(x1, y1);
      path.cubicTo(x1, y1, x2, y2, x3, y3);
    }

    var paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red.withOpacity(0.2)
      ..strokeWidth = 0.1;

    for (var i = 0; i < 3000; ++i) {
      var x1 = rand.nextDouble() * size.width + 300;
      var y1 = rand.nextDouble() * size.height - 400;
      var x2 = rand.nextDouble() * size.width + 300;
      var y2 = rand.nextDouble() * size.height + 300;
      var x3 = rand.nextDouble() * size.width - 100;
      var y3 = rand.nextDouble() * size.height + 300;

      path2.moveTo(x1, y1);
      path2.cubicTo(x2, y2, x3, y3, x1, y1);
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
