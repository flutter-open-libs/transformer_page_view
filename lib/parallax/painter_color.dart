import 'package:flutter/widgets.dart';

import '../bean/transformer_info.dart';

class ColorPainter extends CustomPainter {
  final Paint _paint;
  final TransformInfo info;
  final List<Color> colors;

  ColorPainter(this._paint, this.info, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    int index = info.fromIndex;
    _paint.color = colors[index];
    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
    if (info.done) {
      return;
    }
    int alpha;
    int color;
    double opacity;
    double position = info.position;
    if (info.forward) {
      if (index < colors.length - 1) {
        color = colors[index + 1].value & 0x00ffffff;
        opacity = (position <= 0
            ? (-position / info.viewportFraction)
            : 1 - position / info.viewportFraction);
        if (opacity > 1) {
          opacity -= 1.0;
        }
        if (opacity < 0) {
          opacity += 1.0;
        }
        alpha = (0xff * opacity).toInt();

        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    } else {
      if (index > 0) {
        color = colors[index - 1].value & 0x00ffffff;
        opacity = (position > 0
            ? position / info.viewportFraction
            : (1 + position / info.viewportFraction));
        if (opacity > 1) {
          opacity -= 1.0;
        }
        if (opacity < 0) {
          opacity += 1.0;
        }
        alpha = (0xff * opacity).toInt();

        _paint.color = Color((alpha << 24) | color);
        canvas.drawRect(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(ColorPainter oldDelegate) {
    return oldDelegate.info != info;
  }
}
