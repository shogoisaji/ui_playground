import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  const TagSelector({super.key});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> with SingleTickerProviderStateMixin {
  static const double _centerObjectSize = 80.0;
  static const double _navbarHeight = 100.0;

  IconData? _selectedIcon;

  late AnimationController _centerObjectController;
  late Animation<double> _centerObjectAnimation;
  late Animation<double> _itemsAnimation;
  late Animation<double> _centerItemAnimation;

  @override
  void initState() {
    super.initState();
    _centerObjectController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _centerObjectAnimation = CurvedAnimation(parent: _centerObjectController, curve: Curves.easeOutCubic);
    _centerItemAnimation = CurvedAnimation(
      parent: _centerObjectController,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.easeIn,
      ),
    );
    _itemsAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _centerObjectController,
        curve: const Interval(
          0.6,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  void selectIcon(IconData icon) {
    setState(() {
      _selectedIcon = icon;
    });
    _centerObjectController.reverse(from: 0.6);
  }

  @override
  void dispose() {
    _centerObjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // selected icon view
          Center(
              child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.orange[700]!,
                width: 2,
              ),
            ),
            child: Icon(
              _selectedIcon,
              size: 100,
              color: Colors.orange[700],
            ),
          )),
          // navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 200, //仮
              color: Colors.blueGrey[100],
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Positioned(
                    bottom: _navbarHeight - 60 + 10, // 初期の小さい玉の高さ
                    left: MediaQuery.sizeOf(context).width / 2 - _centerObjectSize / 2,
                    child: AnimatedBuilder(
                        animation: _centerObjectAnimation,
                        builder: (context, child) => Transform.scale(
                            scale: 1 + _centerObjectAnimation.value * 3,
                            child: GestureDetector(
                              onTap: () {
                                if (_centerObjectController.status == AnimationStatus.completed) {
                                  // _centerObjectController.reverse(from: 0.6);
                                  return;
                                } else {
                                  _centerObjectController.forward();
                                }
                              },
                              child: Container(
                                  width: _centerObjectSize,
                                  height: _centerObjectSize,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[900],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, -2 + _centerObjectAnimation.value * 3),
                                      )
                                    ],
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _itemsAnimation,
                                    builder: (context, child) => Stack(
                                      children: [
                                        Center(
                                          child:
                                              // inner shadow
                                              Container(
                                                  width: _centerObjectSize * 0.55,
                                                  height: _centerObjectSize * 0.55,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white.withOpacity(0.2),
                                                      spreadRadius: 15,
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 1),
                                                    )
                                                  ]),
                                                  child:
                                                      // center initial icon
                                                      AnimatedBuilder(
                                                    animation: _centerItemAnimation,
                                                    builder: (context, child) => Opacity(
                                                      opacity: 1 - _centerItemAnimation.value,
                                                      child: const Icon(
                                                        Icons.room,
                                                        color: Colors.white,
                                                        size: 36,
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                        _selectItem(Icons.directions_run, _centerObjectSize, _itemsAnimation.value,
                                            -1.1, selectIcon),
                                        _selectItem(Icons.directions_car, _centerObjectSize, _itemsAnimation.value,
                                            -0.4, selectIcon),
                                        _selectItem(Icons.directions_bus, _centerObjectSize, _itemsAnimation.value, 0.4,
                                            selectIcon),
                                        _selectItem(Icons.directions_bike, _centerObjectSize, _itemsAnimation.value,
                                            1.1, selectIcon),
                                      ],
                                    ),
                                  )),
                            ))),
                  ),
                  Positioned(
                    bottom: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: _navbarHeight,
                        child: AnimatedBuilder(
                          animation: _centerObjectAnimation,
                          builder: (context, child) => CustomPaint(
                            painter: NavigationPainter(
                              width: MediaQuery.sizeOf(context).width,
                              height: _navbarHeight,
                              centerHeight: 60 * (1 - _centerObjectAnimation.value),
                              color: Colors.blueGrey[900]!,
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
        ],
      ),
    );
  }
}

Widget _selectItem(IconData icon, double centerObjectSize, double animationValue, double angle, Function selectIcon) {
  return Opacity(
    opacity: animationValue,
    child: Transform.rotate(
      angle: angle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -30, // 調整
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      selectIcon(icon);
                    },
                    child: SizedBox(
                      width: centerObjectSize,
                      height: centerObjectSize,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: Container(
                              width: centerObjectSize * 0.1,
                              height: centerObjectSize * 0.1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              icon,
                              color: Colors.orange[300]!,
                              size: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class NavigationPainter extends CustomPainter {
  final double width;
  final double height;
  final Color color;
  final double centerHeight;
  NavigationPainter({
    required this.width,
    required this.color,
    required this.height,
    required this.centerHeight,
  });

  static const double _centerWidth = 180.0;
  static const double _upperStrength = 50;
  static const double _underStrength = 50;
  static const double _outSideOffset = 20;

  @override
  void paint(Canvas canvas, Size size) {
    Offset p0 = Offset(-_outSideOffset, 0);
    Offset p1 = Offset((width - _centerWidth) / 2, 0);
    Offset p2 = Offset((width - _centerWidth) / 2 + _upperStrength, 0);
    Offset p3 = Offset(width / 2 - _underStrength, centerHeight);
    Offset p4 = Offset(width / 2, centerHeight);
    Offset p5 = Offset(width / 2 + _underStrength, centerHeight);
    Offset p6 = Offset(width - (width - _centerWidth) / 2 - _upperStrength, 0);
    Offset p7 = Offset(width - (width - _centerWidth) / 2, 0);
    Offset p8 = Offset(width + _outSideOffset, 0);
    Offset p9 = Offset(width + _outSideOffset, height);
    Offset p10 = Offset(-_outSideOffset, height);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dropShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    final innerShadowPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20.0);

    Path path = Path();

    path
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..cubicTo(p2.dx, p2.dy, p3.dx, p3.dy, p4.dx, p4.dy)
      ..cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy)
      ..lineTo(p8.dx, p8.dy)
      ..lineTo(p9.dx, p9.dy)
      ..lineTo(p10.dx, p10.dy);

    canvas.drawPath(path.shift(Offset(0, -3)), dropShadowPaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path.shift(Offset(0, 3)), innerShadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
