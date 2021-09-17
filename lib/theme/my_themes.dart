import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemes {
  static final light = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: "QuickSand",
        ),
    dividerColor: ThemeData.light().colorScheme.onSurface,
    highlightColor: Colors.green,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          ThemeData.light().colorScheme.onSurface,
        ),
        textStyle: MaterialStateProperty.all(
          Get.textTheme.button.copyWith(
            fontSize: Get.width * 0.05,
            fontFamily: "QuickSand",
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeData.light().scaffoldBackgroundColor,
        ),
        elevation: MaterialStateProperty.all(10),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.elliptical(8, 5),
            ),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all(ThemeData.light().colorScheme.onSurface),
        padding: MaterialStateProperty.all(EdgeInsets.all(Get.width * 0.04)),
        shape: MaterialStateProperty.all(CircleBorder()),
        side: MaterialStateProperty.all(
          BorderSide(
            style: BorderStyle.none,
          ),
        ),
      ),
    ),
  );
}
