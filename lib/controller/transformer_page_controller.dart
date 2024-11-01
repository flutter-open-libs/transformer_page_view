library transformer_page_view;

import 'package:flutter/widgets.dart';


const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  Default auto play transition duration (in millisecond)
const int kDefaultTransactionDuration = 300;

class TransformerPageController extends PageController {
  final bool loop;
  final int itemCount;
  final bool reverse;

  TransformerPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    this.loop = false,
    this.itemCount = 0,
    this.reverse = false,
  }) : super(
    initialPage: TransformerPageController._getRealIndexFromRenderIndex(initialPage, loop, itemCount, reverse),
    keepPage: keepPage,
    viewportFraction: viewportFraction);

  int getRenderIndexFromRealIndex(int index) {
    return _getRenderIndexFromRealIndex(index, loop, itemCount, reverse);
  }

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return loop ? itemCount + kMaxValue : itemCount;
  }

  static _getRenderIndexFromRealIndex(int index, bool loop, int itemCount, bool reverse) {
    if (itemCount == 0) return 0;
    int renderIndex;
    if (loop) {
      renderIndex = index - kMiddleValue;
      renderIndex = renderIndex % itemCount;
      if (renderIndex < 0) {
        renderIndex += itemCount;
      }
    } else {
      renderIndex = index;
    }
    if (reverse) {
      renderIndex = itemCount - renderIndex - 1;
    }

    return renderIndex;
  }

  double get realPage {
    double? page;
    // if (position.maxScrollExtent == null || position.minScrollExtent == null) {
    //   page = 0.0;
    // } else {
      page = super.page;
    // }

    return page ?? 0.0;
  }

  static _getRenderPageFromRealPage(double page, bool loop, int itemCount, bool reverse) {
    double renderPage;
    if (loop) {
      renderPage = page - kMiddleValue;
      renderPage = renderPage % itemCount;
      if (renderPage < 0) {
        renderPage += itemCount;
      }
    } else {
      renderPage = page;
    }
    if (reverse) {
      renderPage = itemCount - renderPage - 1;
    }

    return renderPage;
  }

  double get page {
    return loop ? _getRenderPageFromRealPage(realPage, loop, itemCount, reverse) : realPage;
  }

  int getRealIndexFromRenderIndex(int index) {
    return _getRealIndexFromRenderIndex(index, loop, itemCount, reverse);
  }

  static int _getRealIndexFromRenderIndex(int index, bool loop, int itemCount, bool reverse) {
    int result = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      result += kMiddleValue;
    }
    return result;
  }
}
