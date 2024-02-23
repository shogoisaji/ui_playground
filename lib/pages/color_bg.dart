import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'dart:ui' as ui;

import 'package:ui_playground/animations/reflect_animation.dart';

class ColorBgPage extends StatefulWidget {
  const ColorBgPage({super.key});

  @override
  State<ColorBgPage> createState() => _ColorBgPageState();
}

class _ColorBgPageState extends State<ColorBgPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _reflectAnimation;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Offset> _offsets = List.generate(5, (index) => const Offset(0, 0));
  final double _size = 170.0;
  final double _sizeDiff = 15.0;
  ValueNotifier<Offset> _offsetNotifier = ValueNotifier<Offset>(Offset.zero);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    for (int i = 0; i < _offsets.length; i++) {
      _offsets[i] = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
    }
  }

  double randomValue = 0.0;

  Offset calcOffset(double t, Offset center) {
    double x = (150 + randomValue * 100) * sin(4 * t * pi) + center.dx;
    double y = (300) * cos(2 * t * pi) + center.dy;

    return Offset(x, y);
  }

  @override
  void initState() {
    super.initState();
    print('initState');
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 5 + (randomValue * 10).toInt()));
    _reflectAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addListener(() {
        if (_controller.value == 0) {
          setState(() {
            randomValue = Random().nextDouble();
          });
        }
        ;
        _offsetNotifier.value = calcOffset(_animation.value, MediaQuery.of(context).size.center(Offset.zero));
      });
    _controller.repeat(reverse: false);
    _offsetNotifier.addListener(() {
      _updateOffsetsAsync();
    });
  }

  Future<void> _updateOffsetsAsync() async {
    for (int i = 0; i < _offsets.length; i++) {
      setState(() {
        _offsets[i] = calcOffset(_animation.value - 0.02 * i, MediaQuery.of(context).size.center(Offset.zero));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: rive.RiveAnimation.asset(
                'assets/rive/bg.riv',
                animations: ['loop'],
                fit: BoxFit.fill,
              )),
          ...List.generate(
              _offsets.length,
              (index) => Positioned(
                    top: _offsets[index].dy - (_size - _sizeDiff) / 2 + _sizeDiff * index,
                    left: _offsets[index].dx - (_size - _sizeDiff) / 2 + _sizeDiff * index,
                    child: _gradientContainer(index),
                  )),
          ReflectAnimation(
            animationController: _controller,
            screenSize: MediaQuery.of(context).size,
            widgetSize: Size(w * 0.5, w * 0.5),
            child: AnimatedBuilder(
              animation: _reflectAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _reflectAnimation.value * 2 * pi,
                  child: Container(
                    width: w * 0.5,
                    height: w * 0.5,
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: w * 0.2,
                      height: w * 0.2,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.red.withOpacity(0.8),
                            Colors.red.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            children: [
              SamplePage(),
              Container(
                width: w,
                height: h,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == 0) {
                  _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                } else if (_currentPage == 1) {
                  _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientContainer(int index) {
    return Container(
      width: _size - _sizeDiff * index,
      height: _size - _sizeDiff * index,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.blue.withOpacity((_offsets.length - index) * 0.05 + 0.0),
            Colors.blue.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

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
                                  Image.asset(
                                    'assets/images/person.png',
                                    width: 100,
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
                            height: h * 0.2,
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
                              height: h * 0.2,
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
