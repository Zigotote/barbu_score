import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenHelper {
  static final FlutterView _view =
      WidgetsBinding.instance.platformDispatcher.views.first;

  static Size get size => _view.physicalSize / _view.devicePixelRatio;

  static double get width => size.width;

  static double get height => size.height;
}