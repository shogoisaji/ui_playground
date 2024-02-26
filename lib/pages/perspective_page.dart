import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PerspectivePage extends StatefulWidget {
  const PerspectivePage({super.key});

  @override
  State<PerspectivePage> createState() => _PerspectivePageState();
}

class _PerspectivePageState extends State<PerspectivePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _image;
  bool _isViewShown = false;
  int _currentSlideIndex = 0;

  Future<void> loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    _image = fi.image;
    setState(() {});
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    super.initState();
    loadImage('assets/images/picture1.jpg');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    List<Widget> imageSliders = [
      ...List.generate(4, (index) {
        return GestureDetector(
          onTap: () {
            _controller.reverse();
            setState(() {
              _isViewShown = !_isViewShown;
            });
            loadImage('assets/images/picture${index + 1}.jpg');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/picture${index + 1}.jpg',
              fit: BoxFit.fill,
            ),
          ),
        );
      }),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/sky.jpg',
              width: w,
              height: h * 0.4,
              fit: BoxFit.fill,
            ),
          ),
          Container(
              width: w,
              height: h,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final Animation<double> _animation = CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOutBack,
                  );
                  return _image != null
                      ? CustomPaint(
                          painter: PerspectivePainter(
                            level: _animation.value,
                            w: w,
                            h: h,
                            image: _image!,
                          ),
                        )
                      : Container();
                },
              )),
          _isViewShown
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controller.value,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                height: h * 0.25,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 0.7,
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    autoPlayInterval: const Duration(seconds: 2),
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        _currentSlideIndex = index;
                                      });
                                    },
                                  ),
                                  items: imageSliders,
                                )),
                            const SizedBox(height: 10),
                            AnimatedSmoothIndicator(
                              activeIndex: _currentSlideIndex,
                              count: imageSliders.length,
                              effect: WormEffect(
                                dotHeight: 16,
                                dotWidth: 16,
                                dotColor: Colors.white.withOpacity(0.5),
                                activeDotColor: Colors.orange,
                                type: WormType.thinUnderground,
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          _isViewShown
              ? Container()
              : Align(
                  alignment: const Alignment(0.0, 0.3),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSlideIndex = 0;
                        _isViewShown = true;
                      });
                      if (_controller.status == AnimationStatus.completed) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                    },
                    child: const Text('select'),
                  ),
                ),
        ],
      ),
    );
  }
}

class PerspectivePainter extends CustomPainter {
  final ui.Image image;
  final double level;
  final double w;
  final double h;
  PerspectivePainter({required this.level, required this.w, required this.h, required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final wValue = 0.9 - (level * 0.3);
    final hValueUpper = 0.9 - (level * 0.3);
    final hValueLower = 0.85 - (level * 0.1);
    final topHeight = h * 0.2;
    final bottomHeight = h * 0.6;
    final sideOffset = w * 0.1 / 2;
    final Offset p1 = Offset(w * (1 - wValue) / 2 + sideOffset, bottomHeight * (1 - hValueUpper) / 2 + topHeight); //左上
    final Offset p2 =
        Offset(w * (1 - wValue) / 2 + w * wValue - sideOffset, bottomHeight * (1 - hValueUpper) / 2 + topHeight); //右上
    final Offset p3 = Offset(w * (1 - wValue) / 2 + w * wValue - sideOffset,
        bottomHeight * (1 - hValueLower) / 2 + hValueLower * bottomHeight); //右下
    final Offset p4 = Offset(
        w * (1 - wValue) / 2 + sideOffset, bottomHeight * (1 - hValueLower) / 2 + hValueLower * bottomHeight); //左下
    var paint1 = Paint()
      ..color = Colors.green[400]!
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = Colors.green[500]!
      ..style = PaintingStyle.fill;
    var paint3 = Paint()
      ..color = Colors.green[600]!
      ..style = PaintingStyle.fill;
    var paint4 = Paint()
      ..color = Colors.green[700]!
      ..style = PaintingStyle.fill;

    Path path0 = Path();
    Path path1 = Path();
    Path path2 = Path();
    Path path3 = Path();
    Path path4 = Path();
    Path path5 = Path();
    path0
      ..moveTo(p1.dx, p1.dy)
      ..addRect(Rect.fromPoints(Offset(p1.dx, p1.dy), Offset(p3.dx, p3.dy)));

    path1
      ..moveTo(sideOffset, topHeight)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p4.dx, p4.dy)
      ..lineTo(sideOffset, bottomHeight)
      ..close();

    path2
      ..moveTo(w - sideOffset, topHeight)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(w - sideOffset, bottomHeight)
      ..close();

    path3
      ..moveTo(0 + sideOffset, bottomHeight)
      ..lineTo(p4.dx, p4.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(w - sideOffset, bottomHeight)
      ..close();
    path4
      ..moveTo(0 + sideOffset, topHeight)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(w - sideOffset, topHeight)
      ..close();
    path5
      ..moveTo(0, topHeight)
      ..lineTo(sideOffset, topHeight)
      ..lineTo(sideOffset, bottomHeight)
      ..lineTo(w - sideOffset, bottomHeight)
      ..lineTo(w - sideOffset, topHeight)
      ..lineTo(w, topHeight)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path0, paint1);
    canvas.drawPath(path1, paint2);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
    canvas.drawPath(path5, paint4);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4) // 影の色を設定
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

    final Rect rect = Rect.fromPoints(Offset(p1.dx + 15, p1.dy + 15), Offset(p3.dx - 15, p3.dy + 15));
    final RRect rRect = RRect.fromRectAndRadius(
        Rect.fromPoints(Offset(p1.dx + 10, p1.dy + 20), Offset(p3.dx - 10, p3.dy + 20)), const Radius.circular(20));

    // 角が丸い矩形のパスを作成
    final Path pathI = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20))); // ここで角の丸みを調整
    canvas.drawRRect(rRect, shadowPaint);

    canvas.clipPath(pathI);

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
