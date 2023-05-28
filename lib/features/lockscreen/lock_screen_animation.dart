import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class SecretsWithCustomAnimation extends StatefulWidget {
  const SecretsWithCustomAnimation({
    super.key,
    required this.config,
    required this.length,
    required this.input,
    required this.verifyStream,
  });

  final SecretsConfig config;
  final int length;
  final ValueListenable<String> input;
  final Stream<bool> verifyStream;

  @override
  State<SecretsWithCustomAnimation> createState() =>
      _SecretsWithCustomAnimationState();
}

class _SecretsWithCustomAnimationState extends State<SecretsWithCustomAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    widget.verifyStream.listen((valid) {
      if (!valid) {
        // scale animation.
        _animationController.forward();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    _animation = Tween<double>(begin: 1, end: 2).animate(_animationController)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          }
        },
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Secrets(
        input: widget.input,
        length: widget.length,
        config: widget.config,
      ),
    );
  }
}
