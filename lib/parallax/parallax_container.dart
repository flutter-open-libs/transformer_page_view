import 'package:flutter/widgets.dart';

class ParallaxContainer extends StatelessWidget {
  final Widget child;
  final double position;
  final double translationFactor;
  final double opacityFactor;

  const ParallaxContainer(
      {super.key,
      required this.child,
      required this.position,
      this.translationFactor = 100.0,
      this.opacityFactor = 1.0});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - position.abs()).clamp(0.0, 1.0) * opacityFactor,
      child: Transform.translate(
        offset: Offset(position * translationFactor, 0.0),
        child: child,
      ),
    );
  }
}
