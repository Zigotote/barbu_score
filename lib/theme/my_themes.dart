import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemes {
  static final light = _baseTheme(ThemeData.light());

  static final dark = _baseTheme(ThemeData.dark());

  static final _baseTheme = (ThemeData baseTheme) => baseTheme.copyWith(
        useMaterial3: true,
        colorScheme: baseTheme.colorScheme.copyWith(
          surfaceTint: baseTheme.scaffoldBackgroundColor,
          error: baseTheme.brightness == Brightness.dark
              ? Colors.red
              : Colors.red.shade900,
        ),
        textTheme: baseTheme.textTheme
            .copyWith(
              titleSmall: TextStyle(
                fontSize: 20,
                color: baseTheme.colorScheme.onSurface,
              ),
            )
            .apply(
              fontFamily: "QuickSand",
            ),
        dialogBackgroundColor: baseTheme.scaffoldBackgroundColor,
        disabledColor: Colors.grey,
        dividerColor: baseTheme.colorScheme.onSurface,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return baseTheme.colorScheme.onSurface;
            }),
            textStyle: MaterialStatePropertyAll(
              Get.textTheme.labelLarge!.copyWith(
                fontSize: 22,
                fontFamily: "QuickSand",
              ),
            ),
            backgroundColor:
                MaterialStatePropertyAll(baseTheme.scaffoldBackgroundColor),
            overlayColor: MaterialStatePropertyAll(Colors.grey),
            elevation: MaterialStatePropertyAll(10),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(8, 5)),
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
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(baseTheme.scaffoldBackgroundColor),
            foregroundColor:
                MaterialStatePropertyAll(baseTheme.colorScheme.onSurface),
            padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
            shape: MaterialStatePropertyAll(CircleBorder()),
            side: MaterialStatePropertyAll(BorderSide(style: BorderStyle.none)),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(baseTheme.scaffoldBackgroundColor),
            foregroundColor:
                MaterialStatePropertyAll(baseTheme.colorScheme.onSurface),
            overlayColor: MaterialStatePropertyAll(Colors.grey),
            side: MaterialStatePropertyAll(
              BorderSide(color: baseTheme.colorScheme.onSurface),
            ),
          ),
        ),
      );
}

extension CustomThemeValues on ColorScheme {
  Color get successColor =>
      this.brightness == Brightness.dark ? Colors.green : Colors.green.shade800;
}
