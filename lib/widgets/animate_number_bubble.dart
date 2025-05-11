import 'package:flutter/material.dart';

import '../responsive/size_config.dart';

class AnimatedNumberBubble extends StatefulWidget {
  final int number;

  const AnimatedNumberBubble({Key? key, required this.number})
      : super(key: key);

  @override
  State<AnimatedNumberBubble> createState() => _AnimatedNumberBubbleState();
}

class _AnimatedNumberBubbleState extends State<AnimatedNumberBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockWidth * 2,
            vertical: SizeConfig.blockHeight * 1.2,
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
          ),
          child: Text(
            widget.number.toString(),
            style: TextStyle(
              fontSize: SizeConfig.blockWidth * 4,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
