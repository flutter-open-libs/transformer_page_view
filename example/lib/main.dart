import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:sing_transformer_page_view/export.dart';

void main() => runApp(const MyApp());
List<Color> list = [Colors.yellow, Colors.green, Colors.blue];

List<String> images = [
  "assets/Hepburn2.jpg",
  "assets/Hepburn5.jpg",
  "assets/Hepburn4.jpg",
];

List<String> images1 = ["assets/1.jpg", "assets/2.jpg", "assets/3.jpg"];

List<String> text0 = ["春归何处。寂寞无行路", "春无踪迹谁知。除非问取黄鹂", "山色江声相与清，卷帘待得月华生"];
List<String> text1 = ["若有人知春去处。唤取归来同住", "百啭无人能解，因风飞过蔷薇", "可怜一曲并船笛，说尽故人离别情。"];
final List<String> images2 = [
  "assets/home.png",
  "assets/good.png",
  "assets/image.png",
  "assets/edit.png"
];

final List<String> titles = [
  "Welcome",
  "Simple to use",
  "Easy parallax",
  "Customizable"
];
final List<String> subtitles = [
  "Flutter TransformerPageView, for welcome screen, banner, image catalog and more",
  "Simple api,easy to understand,powerful adn strong",
  "Create parallax by a few lines of code",
  "Highly customizable, the only boundary is our mind. :)"
];

final List<Color> backgroundColors = [
  const Color(0xffF67904),
  const Color(0xffD12D2E),
  const Color(0xff7A1EA1),
  const Color(0xff1773CF)
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IndexController _controller = IndexController();
  FixedExtentScrollController controller = FixedExtentScrollController();
  int _index0 = 0;
  int _index1 = 0;
  int _index2 = 0;
  int _index3 = 0;
  int _index4 = 0;
  int _index5 = 0;
  int _index6 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 引导页
            SizedBox(
              height: 500,
              child: TransformerPageView(
                  loop: false,
                  transformer: PageTransformerBuilder(
                      builder: (Widget child, TransformInfo info) {
                        return ParallaxColor(
                          colors: backgroundColors,
                          info: info,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: ParallaxContainer(
                                    position: info.position,
                                    opacityFactor: 1.0,
                                    translationFactor: 400.0,
                                    child: Image.asset(images2[info.index]),
                                  )
                              ),
                              ParallaxContainer(
                                position: info.position,
                                translationFactor: 100.0,
                                child: Text(
                                  titles[info.index],
                                  style: const TextStyle(fontSize: 30.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ParallaxContainer(
                                position: info.position,
                                translationFactor: 50.0,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 50.0),
                                    child: Text(subtitles[info.index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13.0, color: Colors.white))),
                              ),
                            ],
                          ),
                        );
                      }),
                  itemCount: 4),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 500,
              child: TransformerPageView(
                  loop: true,
                  viewportFraction: 0.8,
                  transformer: PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
                    return Material(
                      elevation: 4.0,
                      textStyle: const TextStyle(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ParallaxImage.asset(images1[info.index], position: info.position,),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [Color(0xFF000000), Color(0x33FFC0CB),],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10.0,
                            right: 10.0,
                            bottom: 10.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ParallaxContainer(
                                  position: info.position,
                                  translationFactor: 300.0,
                                  child: Text(text0[info.index], style: const TextStyle(fontSize: 15.0),),
                                ),
                                const SizedBox(height: 8.0),
                                ParallaxContainer(
                                  position: info.position,
                                  translationFactor: 200.0,
                                  child: Text(text1[info.index], style: const TextStyle(fontSize: 18.0)),
                                ),
                              ],
                            ),

                          )
                        ],
                      ),
                    );
                  }),
                  itemCount: 3),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: 500,
                child: TransformerPageView(
                    loop: true,
                    index: _index0,
                    viewportFraction: 1.0,
                    controller: _controller,
                    transformer: PageTransformerBuilder(builder: (w, i) => w),
                    onPageChanged: (int index) {
                      setState(() {
                        _index0 = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                    itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
                height: 500,
                child: TransformerPageView(
                    loop: true,
                    index: _index1,
                    viewportFraction: 1.0,
                    controller: _controller,
                    transformer: AccordionTransformer(),
                    onPageChanged: (int index) {
                      setState(() {
                        _index1 = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                    itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
                height: 500,
                child: TransformerPageView(
                    loop: true,
                    index: _index2,
                    viewportFraction: 1.0,
                    controller: _controller,
                    transformer: ThreeDTransformer(),
                    onPageChanged: (int index) {
                      setState(() {
                        _index2 = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                    itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
                          height: 500,
                          child: TransformerPageView(
                              loop: true,
                              index: _index3,
                              viewportFraction: 0.8,
                              controller: _controller,
                              transformer: ScaleAndFadeTransformer(),
                              onPageChanged: (int index) {
                                setState(() {
                                  _index3 = index;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                              itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
               height: 500,
               child: TransformerPageView(
                  loop: true,
                  index: _index4,
                  viewportFraction: 1.0,
                  controller: _controller,
                  transformer: ZoomInPageTransformer(),
                  onPageChanged: (int index) {
                    setState(() {
                      _index4 = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                  itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
                height: 500,
                child: TransformerPageView(
                    loop: true,
                    index: _index5,
                    viewportFraction: 1.0,
                    controller: _controller,
                    transformer: ZoomOutPageTransformer(),
                    onPageChanged: (int index) {
                      setState(() {
                        _index5 = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                    itemCount: 3)),
            const SizedBox(height: 10),
            SizedBox(
                height: 500,
                child: TransformerPageView(
                    loop: true,
                    index: _index6,
                    viewportFraction: 1.0,
                    controller: _controller,
                    transformer: DeepthPageTransformer(),
                    onPageChanged: (int index) {
                      setState(() {
                        _index6 = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) => Image.asset(images[index], fit: BoxFit.fill),
                    itemCount: 3))
          ],
        ),
      ),
    );
  }
}
