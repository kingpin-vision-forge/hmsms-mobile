import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const CustomAnimatedIcon(
      {super.key, required this.icon, required this.color, required this.size});

  @override
  State<CustomAnimatedIcon> createState() => _CustomAnimatedIconState();
}

class _CustomAnimatedIconState extends State<CustomAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
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
      builder: (_, __) {
        final scale = 1.0 + (_controller.value * 0.1); // 1.0 - 1.1
        final color = Color.lerp(widget.color.withValues(alpha: 0.4),
            widget.color.withValues(alpha: 1), _controller.value);

        return Transform.scale(
          scale: scale,
          child: Icon(
            widget.icon,
            size: widget.size,
            color: color,
          ),
        );
      },
    );
  }
}