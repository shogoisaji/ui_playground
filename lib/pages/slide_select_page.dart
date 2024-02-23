import 'package:flutter/material.dart';

class SlideSelectPage extends StatefulWidget {
  const SlideSelectPage({super.key});

  @override
  State<SlideSelectPage> createState() => _SlideSelectPageState();
}

class _SlideSelectPageState extends State<SlideSelectPage> {
  final _controller = PageController();
  final itemLength = 6;
  double slideValue = 0.0;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Container(
                    height: h * 0.5,
                    width: h * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 7,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: PageView(
                        padEnds: false,
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        children: [
                          ...List.generate(6, (index) {
                            return GestureDetector(
                              onTap: () {
                                //
                              },
                              child: Image.asset(
                                'assets/images/drink${index + 1}.png',
                                fit: BoxFit.contain,
                              ),
                            );
                          }),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  slideValue = (slideValue + details.delta.dy).clamp(0, h * 0.35);
                  _controller.animateToPage((slideValue ~/ (h * 0.35 / itemLength)).toInt(),
                      duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                });
              },
              child: Container(
                width: w * 0.15,
                height: h * 0.35 - slideValue + 50,
                decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  slideValue = (slideValue - details.delta.dx).clamp(0, h * 0.35);
                  _controller.animateToPage((slideValue ~/ (h * 0.35 / itemLength)).toInt(),
                      duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                });
              },
              child: Container(
                  width: w * 0.25 + slideValue + 50,
                  height: w * 0.15,
                  decoration: BoxDecoration(color: Colors.red[300], borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),
    );
  }
}
