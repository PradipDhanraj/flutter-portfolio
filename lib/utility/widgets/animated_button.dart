import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool rotate;
  final VoidCallback? onPressed;
  final Duration duration;

  const AnimatedIconButton({
    super.key,
    required this.text,
    this.icon = Icons.webhook_sharp,
    this.rotate = false,
    this.onPressed,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
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
  void didUpdateWidget(covariant AnimatedIconButton oldWidget) {
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
    return ElevatedButton.icon(
      onPressed: widget.rotate ? null : widget.onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: widget.rotate ? _controller.value * 6.28319 : 0, // 2*pi
            child: child,
          );
        },
        child: Icon(widget.icon, size: 24, color: Colors.black),
      ),
      label: Text(
        widget.text,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
