import 'package:flutter/material.dart';

import './my_appbar.dart';
import 'lines_background.dart';

/// A page with a beautiful layout
class MyDefaultPage extends Scaffold {
  /// The padding applied around all the pages in the app
  static const appPadding = EdgeInsets.all(16);

  /// The default physics to use for scrolling
  static const physics = ClampingScrollPhysics();

  MyDefaultPage({
    super.key,
    required MyAppBar super.appBar,
    required Widget content,
    Widget? bottomWidget,
    bool hasBackground = false,
  }) : super(
         body: SafeArea(
           child: Stack(
             children: [
               if (hasBackground) LinesBackground(),
               MyScrollView(content: content, bottomWidget: bottomWidget),
             ],
           ),
         ),
       );
}

class MyScrollView extends CustomScrollView {
  MyScrollView({super.key, required Widget content, Widget? bottomWidget})
    : super(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(padding: MyDefaultPage.appPadding, child: content),
          ),
          if (bottomWidget != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: MyDefaultPage.appPadding,
                child: bottomWidget,
              ),
            ),
        ],
      );
}
