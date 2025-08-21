import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final IconData icon;
  final String? text;
  final bool rotate;
  final Duration duration;
  final Color color;
  final double iconSize;

  const AnimatedLogo({
    super.key,
    this.icon = Icons.webhook_sharp,
    this.text,
    this.rotate = false,
    this.color = Colors.white,
    this.iconSize = 100,
    this.duration = const Duration(milliseconds: 5000),
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.rotate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.rotate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.rotate ? _controller.value * 6.28319 : 0, // 2*pi
          child: Icon(widget.icon, size: widget.iconSize, color: widget.color),
        );
      },
      //child: Icon(widget.icon, size: 24, color: widget.color),
    );
  }
}
