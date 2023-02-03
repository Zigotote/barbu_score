import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemes {
  static final light = _baseTheme(ThemeData.light());

  static final dark = _baseTheme(ThemeData.dark());

  static final _baseTheme = (ThemeData baseTheme) => baseTheme.copyWith(
        textTheme: baseTheme.textTheme
            .copyWith(
              subtitle2: TextStyle(
                fontSize: 18,
                color: baseTheme.colorScheme.onSurface,
              ),
            )
            .apply(
              fontFamily: "QuickSand",
            ),
        disabledColor: Colors.grey,
        dividerColor: baseTheme.colorScheme.onSurface,
        highlightColor: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return baseTheme.colorScheme.onSurface;
            }),
            textStyle: MaterialStateProperty.all(
              Get.textTheme.button!.copyWith(
                fontSize: 22,
                fontFamily: "QuickSand",
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              baseTheme.scaffoldBackgroundColor,
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
                color: baseTheme.colorScheme.onSurface,
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
                MaterialStateProperty.all(baseTheme.colorScheme.onSurface),
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
