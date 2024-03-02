import 'package:flutter/material.dart';
import 'dart:math' as math;

class SideSelectorPage extends StatefulWidget {
  const SideSelectorPage({super.key});

  @override
  State<SideSelectorPage> createState() => _SideSelectorPageState();
}

class _SideSelectorPageState extends State<SideSelectorPage> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
          // title: const Text('UI Playground'),
          ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Transform(
                transform: Matrix4.identity()

                  // ..translate(0, 0.0, 0.0)
                  // ..setEntry(3, 2, 0.001)
                  // ..scale(1.0 - 0.9 * animation.value, 1.0 - 0.3 * animation.value, 1)
                  ..rotateY(math.pi / 4 * animation.value),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  width: w,
                  height: h * 0.85,
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
          Align(
            alignment: Alignment.topRight,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                width: w -
                    math.cos(
                          math.pi / 4 * animation.value,
                        ) *
                        w,
                height: h * 0.85,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      width: w,
                      height: h * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey, width: 4),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[100],
                ),
                width: w,
                height: h * 0.15,
                child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                        child: Text('animate')))),
          ),
        ],
      ),
    );
  }
}
