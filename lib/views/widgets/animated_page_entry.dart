import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedPageEntry extends StatelessWidget {
  const AnimatedPageEntry({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 800),
    this.horizontalOffset,  
    this.verticalOffset,
    this.animatorKey,
  }) : assert(verticalOffset == null || horizontalOffset == null, 'Only one of verticalOffset or horizontalOffset can be set');

  final List<Widget> children;
  final Key? animatorKey;
  final Duration duration;
  final double? horizontalOffset;
  final double? verticalOffset;


  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: animatorKey,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: AnimationConfiguration.toStaggeredList(
          duration: duration,
          childAnimationBuilder: (widget) => SlideAnimation(
            curve: Curves.linear,
            verticalOffset: verticalOffset,
            horizontalOffset: horizontalOffset,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }
}
