import 'package:flutter/widgets.dart';

class ParallaxImage extends StatelessWidget {
  final Image image;
  final double imageFactor;

  ParallaxImage.asset(
      String name,
      {super.key,
        double position = 0,
        this.imageFactor = 0.3
      }) : image = Image.asset(name, fit: BoxFit.cover, alignment: FractionalOffset(0.5 + position * imageFactor, 0.5,));

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
