// Animated logo widget
import 'package:flutter/material.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class AnimationScaleWidget extends StatefulWidget {
  const AnimationScaleWidget({super.key});

  @override
  State<AnimationScaleWidget> createState() => _AnimationScaleWidgetState();
}

class _AnimationScaleWidgetState extends State<AnimationScaleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: const AnimatedLogo(rotate: true,),
    );
  }
}
