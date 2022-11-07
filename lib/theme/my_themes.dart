import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemes {
  static final light = ThemeData.light().copyWith(
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          subtitle2: TextStyle(
            fontSize: 18,
            color: ThemeData.light().colorScheme.onSurface,
          ),
        )
        .apply(
          fontFamily: "QuickSand",
        ),
    disabledColor: Colors.grey,
    dividerColor: ThemeData.light().colorScheme.onSurface,
    highlightColor: Colors.green,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return ThemeData.light().colorScheme.onSurface;
        }),
        textStyle: MaterialStateProperty.all(
          Get.textTheme.button!.copyWith(
            fontSize: 22,
            fontFamily: "QuickSand",
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeData.light().scaffoldBackgroundColor,
        ),
        overlayColor: MaterialStateProperty.all(Colors.grey),
        elevation: MaterialStateProperty.all(10),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.elliptical(8, 5),
            ),
          ),
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
          BorderSide border = BorderSide(
            style: BorderStyle.solid,
            width: 2,
          );
          if (states.contains(MaterialState.disabled)) {
            border = border.copyWith(color: Colors.grey);
          }
          return border;
        }),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all(ThemeData.light().colorScheme.onSurface),
        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
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
