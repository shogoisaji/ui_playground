import 'dart:math';

import 'package:flutter/material.dart';

class ReflectAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final Size screenSize;
  final Size widgetSize;

  const ReflectAnimation({
    super.key,
    required this.child,
    required this.animationController,
    required this.screenSize,
    required this.widgetSize,
  });

  @override
  ReflectAnimationState createState() => ReflectAnimationState();
}

const _speed = 1.5;

class ReflectAnimationState extends State<ReflectAnimation> {
  Offset _position = const Offset(0, 0);
  Offset _velocity = const Offset(_speed, _speed);
  Random _random = Random();

  void move() {
    setState(() {
      _position += _velocity;
    });
  }

  void checkVelocityDirection() {
    if (_position.dx < 0) {
      setState(() {
        final double rx = (_random.nextDouble() + 1) * _speed;
        _velocity = Offset(rx, _velocity.dy);
      });
    }
    if (_position.dx > widget.screenSize.width - widget.widgetSize.width) {
      setState(() {
        final double rx = (_random.nextDouble() + 1) * _speed;
        _velocity = Offset(-rx, _velocity.dy);
      });
    }
    if (_position.dy < 0) {
      setState(() {
        final double ry = (_random.nextDouble() + 1) * _speed;
        _velocity = Offset(_velocity.dx, ry);
      });
    }
    if (_position.dy > widget.screenSize.height - widget.widgetSize.height) {
      setState(() {
        final double ry = (_random.nextDouble() + 1) * _speed;
        _velocity = Offset(_velocity.dx, -ry);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.animationController.addListener(() {
      move();
      checkVelocityDirection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) => Transform.translate(
              offset: _position,
              child: widget.child,
            ));
  }
}
