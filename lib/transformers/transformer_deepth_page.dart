import 'package:flutter/material.dart';
import 'package:sing_transformer_page_view/transformer_page_view.dart';
import '../bean/transformer_info.dart';

class DeepthPageTransformer extends PageTransformer {
  DeepthPageTransformer() : super(reverse: true);

  @override
  Widget transform(Widget child, TransformInfo info) {
    double position = info.position;
    if (position <= 0) {
      return Opacity(
        opacity: 1.0,
        child: Transform.translate(
          offset: const Offset(0.0, 0.0),
          child: Transform.scale(
            scale: 1.0,
            child: child,
          ),
        ),
      );
    } else if (position <= 1) {
      const double minScale = 0.75;
      double scaleFactor = minScale + (1 - minScale) * (1 - position);
      return Opacity(
        opacity: 1.0 - position,
        child: Transform.translate(
          offset: Offset(info.width * -position, 0.0),
          child: Transform.scale(
            scale: scaleFactor,
            child: child,
          ),
        ),
      );
    }

    return child;
  }
}
