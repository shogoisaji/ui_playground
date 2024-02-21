import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class ColorBgPage extends StatefulWidget {
  const ColorBgPage({super.key});

  @override
  State<ColorBgPage> createState() => _ColorBgPageState();
}

class _ColorBgPageState extends State<ColorBgPage> {
  List<Offset> _offsets = List.generate(5, (index) => const Offset(0, 0));
  final double _size = 170.0;
  final double _sizeDiff = 15.0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    for (int i = 0; i < _offsets.length; i++) {
      _offsets[i] = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              4,
              (index) => Positioned(
                    top: _offsets[index + 1].dy - (_size - _sizeDiff) / 2 + _sizeDiff * index,
                    left: _offsets[index + 1].dx - (_size - _sizeDiff) / 2 + _sizeDiff * index,
                    child: _gradientContainer(index + 1),
                  )),
          Positioned(
            top: _offsets[0].dy - _size / 2,
            left: _offsets[0].dx - _size / 2,
            child: Draggable(
              feedback: _gradientContainer(0),
              childWhenDragging: Container(
                width: 20,
                height: 20,
                color: Colors.transparent,
              ),
              onDragUpdate: (details) async {
                for (int i = 0; i < _offsets.length; i++) {
                  Future.delayed(Duration(milliseconds: 70 * i), () {
                    setState(() {
                      _offsets[i] += details.delta;
                    });
                  });
                }
              },
              child: _gradientContainer(0),
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
            Colors.blue.withOpacity((_offsets.length - index) * 0.1 + 0.1),
            Colors.blue.withOpacity(0),
          ],
        ),
      ),
    );
  }
}
