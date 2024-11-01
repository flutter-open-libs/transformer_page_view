import 'package:flutter/widgets.dart';

import '../bean/transformer_info.dart';
import 'painter_color.dart';

class ParallaxColor extends StatefulWidget {
  final Widget child;

  final List<Color> colors;

  final TransformInfo info;

  ParallaxColor({
    required this.colors,
    required this.info,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _ParallaxColorState();
  }
}

class _ParallaxColorState extends State<ParallaxColor> {
  Paint paint = Paint();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorPainter(paint, widget.info, widget.colors),
      child: widget.child,
    );
  }
}