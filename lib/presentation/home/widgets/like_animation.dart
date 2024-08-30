import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget widget;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimation({
    super.key,
    required this.widget,
    required this.isAnimating,
    this.duration = const Duration(microseconds: 150),
    this.onEnd,
    this.smallLike = false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        microseconds: widget.duration.inMicroseconds ~/ 2,
      ),
    );
    _scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    try {
      if (widget.isAnimating || widget.smallLike) {
        await _animationController.forward();
        await _animationController.reverse();
        if (widget.onEnd != null) {
          widget.onEnd!();
        }
      }
    } catch (e) {
      // Catch any errors in animation to prevent crashes
      print("Animation error: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: widget.widget,
    );
  }
}
