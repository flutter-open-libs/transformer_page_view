library transformer_page_view;

import 'package:flutter/widgets.dart';

import 'bean/transformer_info.dart';
import 'controller/index_controller.dart';
import 'controller/transformer_page_controller.dart';

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  Default auto play transition duration (in millisecond)
const int kDefaultTransactionDuration = 300;

abstract class PageTransformer {
  final bool reverse;

  PageTransformer({this.reverse = false});

  /// Return a transformed widget, based on child and TransformInfo
  Widget transform(Widget child, TransformInfo info);
}

typedef Widget PageTransformerBuilderCallback(Widget child, TransformInfo info);

class PageTransformerBuilder extends PageTransformer {
  final PageTransformerBuilderCallback builder;

  PageTransformerBuilder({bool reverse = false, required this.builder}): super(reverse: reverse);

  @override
  Widget transform(Widget child, TransformInfo info) {
    return builder(child, info);
  }
}

class TransformerPageView extends StatefulWidget {
  /// Create a `transformed` widget base on the widget that has been passed to  the [PageTransformer.transform].
  /// See [TransformInfo]
  ///
  final PageTransformer? transformer;

  /// Same as [PageView.scrollDirection]
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Same as [PageView.physics]
  final ScrollPhysics? physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  /// Same as [PageView.pageSnapping]
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  /// Same as [PageView.onPageChanged]
  final ValueChanged<int>? onPageChanged;

  final IndexedWidgetBuilder? itemBuilder;

  // See [IndexController.mode],[IndexController.next],[IndexController.previous]
   IndexController? controller;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  final TransformerPageController? pageController;

  /// Set true to open infinity loop mode.
  final bool loop;

  /// This value is only valid when `pageController` is not set,
  final int itemCount;

  /// This value is only valid when `pageController` is not set,
  final double viewportFraction;

  /// If not set, it is controlled by this widget.
  final int index;

  /// Creates a scrollable list that works page by page using widgets that are
  /// created on demand.
  ///
  /// This constructor is appropriate for page views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null [itemCount] lets the [PageView] compute the maximum
  /// scroll extent.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  TransformerPageView({
    Key? key,
    this.index = 0,
    this.duration = const Duration(milliseconds: kDefaultTransactionDuration),
    this.curve = Curves.ease,
    this.viewportFraction = 1.0,
    this.loop = false,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.controller,
    this.transformer,
    this.itemBuilder,
    this.pageController,
    required this.itemCount,
  })  : assert(itemCount == 0 || itemBuilder != null || transformer != null),
        super(key: key) {
    controller ??= IndexController();
  }

  factory TransformerPageView.children(
      {Key? key,
      int index = 0,
      Duration duration = const Duration(milliseconds: kDefaultTransactionDuration),
      Curve curve = Curves.ease,
      double viewportFraction = 1.0,
      bool loop = false,
      Axis scrollDirection = Axis.horizontal,
      ScrollPhysics? physics,
      bool pageSnapping = true,
      ValueChanged<int>? onPageChanged,
      IndexController? controller,
      PageTransformer? transformer,
      required List<Widget> children,
      TransformerPageController? pageController}) {
    return TransformerPageView(
      itemCount: children.length,
      itemBuilder: (BuildContext context, int index) => children[index],
      pageController: pageController,
      transformer: transformer,
      pageSnapping: pageSnapping,
      key: key,
      index: index,
      duration: duration,
      curve: curve,
      viewportFraction: viewportFraction,
      scrollDirection: scrollDirection,
      physics: physics,
      onPageChanged: onPageChanged,
      controller: controller ?? IndexController(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _TransformerPageViewState();
  }

  static int getRealIndexFromRenderIndex(
      {bool reverse = false, int index = 0, int itemCount = 0, bool loop = false}) {
    int initPage = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  static PageController createPageController(
      {bool reverse = false,
      int index = 0,
      int itemCount = 0,
      bool loop = false,
      double viewportFraction = 0}) {
    return PageController(
        initialPage: getRealIndexFromRenderIndex(
            reverse: reverse, index: index, itemCount: itemCount, loop: loop),
        viewportFraction: viewportFraction);
  }
}

class _TransformerPageViewState extends State<TransformerPageView> {
  Size? _size;
  int _activeIndex = 0;
  double _currentPixels = 0;
  bool _done = false;

  ///This value will not change until user end drag.
  int _fromIndex = 0;

  PageTransformer? _transformer;

  late TransformerPageController _pageController;

  Widget _buildItemNormal(BuildContext context, int index) {
    int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    return widget.itemBuilder == null ? const Text("widget.itemBuilder == null") : widget.itemBuilder!(context, renderIndex);
  }

  Widget _buildItem(BuildContext context, int index) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext c, Widget? w) {
          int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
          Widget child = Container();
          if (widget.itemBuilder != null) {
            child = widget.itemBuilder!(context, renderIndex);
          }
          if (_size == null) {
            return child;
          }

          double position;

          double page = _pageController.realPage;

          if (_transformer != null && _transformer!.reverse) {
            position = page - index;
          } else {
            position = index - page;
          }
          position *= widget.viewportFraction;

          TransformInfo info = TransformInfo(
              index: renderIndex,
              width: _size?.width ?? 10,
              height: _size?.height ?? 10,
              position: position.clamp(-1.0, 1.0),
              activeIndex: _pageController.getRenderIndexFromRealIndex(_activeIndex),
              fromIndex: _fromIndex,
              forward: _pageController.position.pixels - _currentPixels >= 0,
              done: _done,
              scrollDirection: widget.scrollDirection,
              viewportFraction: widget.viewportFraction);
          return _transformer!.transform(child, info);
        });
  }

  double _calcCurrentPixels() {
    _currentPixels = _pageController.getRenderIndexFromRealIndex(_activeIndex) *
        _pageController.position.viewportDimension *
        widget.viewportFraction;

    return _currentPixels;
  }

  @override
  Widget build(BuildContext context) {
    IndexedWidgetBuilder builder = _transformer == null ? _buildItemNormal : _buildItem;
    Widget child = PageView.builder(
      itemBuilder: builder,
      itemCount: _pageController.getRealItemCount(),
      onPageChanged: _onIndexChanged,
      controller: _pageController,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      reverse: _pageController.reverse,
    );
    if (_transformer == null) {
      return child;
    }
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            _calcCurrentPixels();
            _done = false;
            _fromIndex = _activeIndex;
          } else if (notification is ScrollEndNotification) {
            _calcCurrentPixels();
            _fromIndex = _activeIndex;
            _done = true;
          }

          return false;
        },
        child: child);
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(_pageController.getRenderIndexFromRealIndex(index));
    }
  }

  void _onGetSize(_) {
    Size? size;
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject != null) {
      Rect bounds = renderObject.paintBounds;
      size = bounds.size;
    }
    _calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size? size) {
    if(mounted){
      setState(() {
        _size = size;
      });
    }

  }

  @override
  void initState() {
    _transformer = widget.transformer;
    _pageController = widget.pageController ?? TransformerPageController(
        initialPage: widget.index,
        itemCount: widget.itemCount,
        loop: widget.loop,
        reverse:
        widget.transformer == null ? false : widget.transformer!.reverse);

    _fromIndex = _activeIndex = _pageController.initialPage;

    _controller = getNotifier();
    if (_controller != null) {
      _controller!.addListener(onChangeNotifier);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    int index = widget.index;
    bool created = false;
    if (_pageController != widget.pageController) {
      if (widget.pageController != null) {
        _pageController = widget.pageController!;
      } else {
        created = true;
        _pageController = TransformerPageController(
            initialPage: widget.index,
            itemCount: widget.itemCount,
            loop: widget.loop,
            reverse: widget.transformer == null
                ? false
                : widget.transformer!.reverse);
      }
    }

    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _fromIndex = _activeIndex = _pageController.initialPage;
      if (!created) {
        int initPage = _pageController.getRealIndexFromRenderIndex(index);
        _pageController.animateToPage(initPage,
            duration: widget.duration, curve: widget.curve);
      }
    }
    if (_transformer != null)
      WidgetsBinding.instance.addPostFrameCallback(_onGetSize);

    if (_controller != getNotifier()) {
      if (_controller != null) {
        _controller!.removeListener(onChangeNotifier);
      }
      _controller = getNotifier();
      if (_controller != null) {
        _controller!.addListener(onChangeNotifier);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    if (_transformer != null)
      WidgetsBinding.instance.addPostFrameCallback(_onGetSize);
    super.didChangeDependencies();
  }

  ChangeNotifier getNotifier() {
    return widget.controller ?? IndexController();
  }

  int _calcNextIndex(bool next) {
    int currentIndex = _activeIndex;
    if (_pageController.reverse) {
      if (next) {
        currentIndex--;
      } else {
        currentIndex++;
      }
    } else {
      if (next) {
        currentIndex++;
      } else {
        currentIndex--;
      }
    }

    if (!_pageController.loop) {
      if (currentIndex >= _pageController.itemCount) {
        currentIndex = 0;
      } else if (currentIndex < 0) {
        currentIndex = _pageController.itemCount - 1;
      }
    }

    return currentIndex;
  }

  void onChangeNotifier() {
    int event = widget.controller?.event ?? 0;
    int index;
    switch (event) {
      case IndexController.MOVE:
        {
          index = _pageController
              .getRealIndexFromRenderIndex(widget.controller?.index ?? 0);
        }
        break;
      case IndexController.PREVIOUS:
      case IndexController.NEXT:
        {
          index = _calcNextIndex(event == IndexController.NEXT);
        }
        break;
      default:
        //ignore this event
        return;
    }
    if (widget.controller?.animation ?? true) {
      _pageController
          .animateToPage(index, duration: widget.duration, curve: widget.curve)
          .whenComplete(widget.controller?.complete ?? ()=>{});
    } else {
      _pageController.jumpToPage(index);
      widget.controller?.complete ?? ()=>{};
    }
  }

  ChangeNotifier? _controller;

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.removeListener(onChangeNotifier);
    }
  }
}
