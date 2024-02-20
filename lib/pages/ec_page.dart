import 'package:flutter/material.dart';
import 'package:ui_playground/models/ec_product.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class EcPage extends StatefulWidget {
  const EcPage({super.key});

  @override
  State<EcPage> createState() => _EcPageState();
}

class _EcPageState extends State<EcPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _selectAnimationController;
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<EcProduct> cartList = [];
  bool isCartShow = false;
  bool isModalShow = false;
  double cartHeight = 0.0;
  double picHeight = 0.0;
  EcProduct? selectProduct;

  Future<List<EcProduct>> fetchProducts() async {
    final String response = await rootBundle.loadString('ec_products.json');
    final data = await json.decode(response) as List;
    final productList = data.map<EcProduct>((json) => EcProduct.fromJson(json)).toList();
    return productList;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.isCompleted) {
        setState(() {
          isCartShow = true;
        });
      }
    });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _selectAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _selectAnimationController.addListener(() {
      if (_selectAnimationController.isCompleted) {
        _selectAnimationController.reset();
        setState(() {
          selectProduct = null;
        });
      }
    });

    _scrollController.addListener(() {
      print(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        title: const Text('EC', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                        future: fetchProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final List<EcProduct> listData = snapshot.data!;
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    color: Colors.blueGrey[100],
                                    child: SizedBox(
                                      height: 112,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              'assets/images/avatar${(index % 9) + 1}.png',
                                              width: 80,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(listData[index].name,
                                                      style:
                                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                  Text('¥${listData[index].price.toString()}',
                                                      style: const TextStyle(fontSize: 20)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    print('商品詳細');
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[300],
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    child: Center(
                                                        child: const Text('キープ',
                                                            style: TextStyle(
                                                                color: Colors.white, fontWeight: FontWeight.bold))),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (_selectAnimationController.isAnimating) return;
                                                    _selectAnimationController.forward();
                                                    setState(() {
                                                      picHeight = index * 120 - _scrollController.offset;
                                                      selectProduct = listData[index];
                                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                                        cartList.add(listData[index]);
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[600],
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    child: Center(
                                                        child: const Text('カートに追加',
                                                            style: TextStyle(
                                                                color: Colors.white, fontWeight: FontWeight.bold))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        }),
                  )
                ],
              )),
          IgnorePointer(
            ignoring: isModalShow ? false : true,
            child: GestureDetector(
              onTap: () {
                print('タップ');
                setState(() {
                  isModalShow = false;
                  isCartShow = false;
                });
                _controller.reverse();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: isModalShow ? Colors.black.withOpacity(0.3) : Colors.transparent,
                // size: const Size(100, 100),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  // size: const Size(100, 100),
                  painter: MyCustomPainter(animateValue: _animation.value, h: 300),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                  top: 50 + _animation.value * 10,
                  right: 10 + _animation.value * 10,
                  child: Container(
                    width: 180 * _animation.value + 60,
                    height: 280 * _animation.value + 60,
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: isCartShow
                        ? ListView.builder(
                            itemCount: cartList.length,
                            itemBuilder: (context, index) {
                              final i = cartList.length - index - 1;
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Image.asset(
                                    'assets/images/${cartList[i].avatar}',
                                    width: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  Column(
                                    children: [
                                      Text(cartList[i].name),
                                      Text('¥${cartList[i].price.toString()}'),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cartList.removeAt(i);
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ]),
                              );
                            },
                          )
                        : Container(),
                  ));
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                  top: 50 + _animation.value * 7,
                  right: 10 + _animation.value * 195,
                  child: Opacity(
                    opacity: 1 - _animation.value,
                    child: InkWell(
                      onTap: () {
                        if (_controller.isAnimating || _controller.isCompleted) {
                          return;
                        }
                        setState(() {
                          isModalShow = true;
                        });

                        _controller.forward();
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: cartList.isNotEmpty
                              ? Image.asset(
                                  'assets/images/${cartList[cartList.length - 1].avatar}',
                                  fit: BoxFit.fill,
                                )
                              : Container()),
                    ),
                  ));
            },
          ),

          // バッチ
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                  top: 80 + _animation.value * 7,
                  right: 5 + _animation.value * 195,
                  child: Opacity(
                    opacity: 1 - _animation.value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartList.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ));
            },
          ),
          AnimatedBuilder(
            animation: _selectAnimationController,
            builder: (context, child) {
              final CurvedAnimation animation =
                  CurvedAnimation(parent: _selectAnimationController, curve: Curves.easeOutBack);
              final w = MediaQuery.sizeOf(context).width - 100;
              final h = picHeight - 40;
              return selectProduct != null
                  ? Positioned(
                      top: picHeight + 20 - animation.value * h,
                      left: 20 + _selectAnimationController.value * w,
                      child: Transform.scale(
                        scale: 1 + 0.8 * _selectAnimationController.value,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            'assets/images/${selectProduct?.avatar}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.animateValue, required this.h});

  final double h;
  final double animateValue; // アニメーションの値

  @override
  void paint(Canvas canvas, Size size) {
    final double animatedHeight = h * animateValue + 80; // 変形する高さ
    final double animatedWidth = 200 * animateValue + 20; // 変形する幅

    const curveStrength = 60.0; // 曲線の強さ
    Offset p1 = Offset(0, curveStrength);
    Offset p2 = Offset(0, curveStrength);
    Offset p3 = Offset(-curveStrength, curveStrength);

    Offset p4 = Offset(-animatedWidth, curveStrength);

    Offset p5 = Offset(-curveStrength - animatedWidth, curveStrength);
    Offset p6 = Offset(-curveStrength - animatedWidth, curveStrength);
    Offset p7 = Offset(-curveStrength - animatedWidth, curveStrength * 2);

    Offset p8 = Offset(-curveStrength - animatedWidth, animatedHeight);

    Offset p9 = Offset(-curveStrength - animatedWidth, curveStrength + animatedHeight);
    Offset p10 = Offset(-curveStrength - animatedWidth, curveStrength + animatedHeight);
    Offset p11 = Offset(-animatedWidth, curveStrength + animatedHeight);

    Offset p12 = Offset(-curveStrength, curveStrength + animatedHeight);

    Offset p13 = Offset(0, curveStrength + animatedHeight);
    Offset p14 = Offset(0, curveStrength + animatedHeight);
    Offset p15 = Offset(0, curveStrength * 2 + animatedHeight);

    final paint = Paint()
      ..color = Colors.orange[400]!
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0; // ペイントのスタイルを設定

    final path = Path();
    path.cubicTo(
      p1.dx,
      p1.dy,
      p2.dx,
      p2.dy,
      p3.dx,
      p3.dy,
    );
    path.lineTo(p4.dx, p4.dy);
    path.cubicTo(
      p5.dx,
      p5.dy,
      p6.dx,
      p6.dy,
      p7.dx,
      p7.dy,
    );
    path.lineTo(p8.dx, p8.dy);
    path.cubicTo(
      p9.dx,
      p9.dy,
      p10.dx,
      p10.dy,
      p11.dx,
      p11.dy,
    );
    path.lineTo(p12.dx, p12.dy);
    path.cubicTo(
      p13.dx,
      p13.dy,
      p14.dx,
      p14.dy,
      p15.dx,
      p15.dy,
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2) // 影の色を設定
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0); // ぼかしの程度を設定

// 影を描画
    canvas.drawPath(path.shift(Offset(-4.0, 4.0)), shadowPaint);

    canvas.drawPath(path, paint); // キャンバスに描画
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
