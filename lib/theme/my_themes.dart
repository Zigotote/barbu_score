import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

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
        textTheme: baseTheme.textTheme.apply(
          fontFamily: "QuickSand",
          displayColor: baseTheme.colorScheme.onSurface,
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
        tabBarTheme: TabBarTheme(
          indicator: ShapeDecoration(
            color: baseTheme.scaffoldBackgroundColor,
            shape: NonUniformBorder(
              leftWidth: 2,
              topWidth: 2,
              rightWidth: 2,
              bottomWidth: 0,
              color: baseTheme.colorScheme.onSurface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(8, 5),
                topRight: Radius.elliptical(8, 5),
              ),
            ),
          ),
          indicatorColor: baseTheme.colorScheme.onSurface,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: baseTheme.colorScheme.onSurface,
          unselectedLabelColor: Colors.grey,
          overlayColor: MaterialStatePropertyAll(Colors.grey),
        ),
      );
}

extension CustomThemeValues on ColorScheme {
  Color get successColor =>
      this.brightness == Brightness.dark ? Colors.green : Colors.green.shade800;

  List<Color> get playerColors => this.brightness == Brightness.dark
      ? [
          Colors.brown.shade400,
          Colors.lightGreen.shade800,
          Colors.yellow.shade700,
          Colors.orange.shade800,
          Colors.deepOrange.shade700,
          Colors.teal.shade400
        ]
      : [
          Colors.brown.shade700,
          Colors.lightGreen.shade900,
          Colors.yellow.shade800,
          Colors.orange.shade800,
          Colors.deepOrange.shade900,
          Colors.teal.shade900,
        ];
}
