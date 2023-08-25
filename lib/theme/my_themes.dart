import 'package:flutter/material.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

class MyThemes {
  MyThemes._();

  static final light = _baseTheme(ThemeData.light());

  static final dark = _baseTheme(ThemeData.dark());

  static _baseTheme(ThemeData baseTheme) {
    final TextTheme textTheme = baseTheme.textTheme.apply(
      fontFamily: "QuickSand",
      displayColor: baseTheme.colorScheme.onSurface,
    );
    const disabledColor = Color(0xffAFAFAF);
    return baseTheme.copyWith(
      useMaterial3: true,
      colorScheme: baseTheme.colorScheme.copyWith(
        surfaceTint: baseTheme.scaffoldBackgroundColor,
        error: baseTheme.brightness == Brightness.dark
            ? Colors.red
            : Colors.red.shade900,
        outline: baseTheme.colorScheme.onSurface,
      ),
      textTheme: textTheme,
      dialogBackgroundColor: baseTheme.scaffoldBackgroundColor,
      disabledColor: disabledColor,
      dividerColor: baseTheme.colorScheme.onSurface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledColor;
            }
            return baseTheme.colorScheme.onSurface;
          }),
          textStyle: MaterialStatePropertyAll(
            textTheme.labelLarge!.copyWith(
              fontSize: 22,
              fontFamily: "QuickSand",
            ),
          ),
          backgroundColor:
              MaterialStatePropertyAll(baseTheme.scaffoldBackgroundColor),
          overlayColor: const MaterialStatePropertyAll(disabledColor),
          elevation: const MaterialStatePropertyAll(10),
          shape: const MaterialStatePropertyAll(
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
              border = border.copyWith(color: disabledColor);
            }
            return border;
          }),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          backgroundColor:
              MaterialStatePropertyAll(baseTheme.scaffoldBackgroundColor),
          foregroundColor:
              MaterialStatePropertyAll(baseTheme.colorScheme.onSurface),
          overlayColor: const MaterialStatePropertyAll(disabledColor),
          side: MaterialStatePropertyAll(
            BorderSide(color: baseTheme.colorScheme.onSurface),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: baseTheme.scaffoldBackgroundColor.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        insetPadding: const EdgeInsets.all(0),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(8, 5),
              topRight: Radius.elliptical(8, 5),
            ),
          ),
        ),
        indicatorColor: baseTheme.colorScheme.onSurface,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: baseTheme.colorScheme.onSurface,
        unselectedLabelColor: disabledColor,
        overlayColor: const MaterialStatePropertyAll(disabledColor),
      ),
    );
  }
}

extension CustomThemeValues on ColorScheme {
  Color get successColor =>
      brightness == Brightness.dark ? Colors.green : Colors.green.shade800;
}
