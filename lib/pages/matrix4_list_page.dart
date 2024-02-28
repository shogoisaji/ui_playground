import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;

class Matrix4ListPage extends HookWidget {
  const Matrix4ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    const listWidth = 300.0;
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    useEffect(() {
      animationController.value = 1.0;

      return () {};
    }, const []);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text('Matrix4 List',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (animationController.isCompleted) {
                animationController.reverse();
              } else {
                animationController.forward();
              }
            },
            child: const Text('animate'),
          ),
          Stack(
            children: [
              // 青
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Transform(
                  transform: Matrix4.identity()
                    ..translate(w - (animation.value) - 600, 0.0, 0.0)
                    ..setEntry(3, 2, 0.001)
                    // ..scale(1.0 - 0.9 * animation.value, 1.0 - 0.3 * animation.value, 1)
                    ..rotateY(math.pi / 2 * (1 - 0.1 * animation.value)),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.blue, width: 4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: listWidth,
                      height: h * 0.8,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: 20, // 仮のアイテム数を設定
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    // color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text('$index', style: TextStyle(fontSize: 20)),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 赤
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 300 * (1 - animation.value), 0.0)
                    ..setEntry(3, 2, -0.001)
                    // ..scale(1, 1, 1)
                    ..rotateX(0 - (1 - animation.value)),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: listWidth,
                      height: h * 0.8,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: 20, // 仮のアイテム数を設定
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    // color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text('$index', style: TextStyle(fontSize: 20)),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
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
        ],
      ),
    );
  }
}
