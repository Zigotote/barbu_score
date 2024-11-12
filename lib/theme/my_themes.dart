import 'package:flutter/material.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

import '../commons/models/player_colors.dart';

class MyThemes {
  MyThemes._();

  static final light = _baseTheme(ThemeData.light());

  static final dark = _baseTheme(ThemeData.dark());

  static _baseTheme(ThemeData baseTheme) {
    final onSurfaceColor = baseTheme.colorScheme.onSurface;
    const disabledColor = Color(0xffAFAFAF);

    final TextTheme textTheme = baseTheme.textTheme.apply(
      fontFamily: "QuickSand",
      displayColor: onSurfaceColor,
    );
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surfaceTint: baseTheme.scaffoldBackgroundColor,
        error: baseTheme.brightness == Brightness.dark
            ? Colors.red
            : Colors.red.shade900,
        outline: onSurfaceColor,
      ),
      textTheme: textTheme,
      dialogBackgroundColor: baseTheme.scaffoldBackgroundColor,
      disabledColor: disabledColor,
      dividerColor: onSurfaceColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowEnterRouteSnapshotting: false,
          ),
        },
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor;
            }
            return onSurfaceColor;
          }),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge!.copyWith(
              fontSize: 22,
              fontFamily: "QuickSand",
            ),
          ),
          backgroundColor:
              WidgetStatePropertyAll(baseTheme.scaffoldBackgroundColor),
          overlayColor: const WidgetStatePropertyAll(disabledColor),
          elevation: const WidgetStatePropertyAll(10),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(8, 5)),
            ),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
              (Set<WidgetState> states) {
            BorderSide border = BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color: onSurfaceColor,
            );
            if (states.contains(WidgetState.disabled)) {
              border = border.copyWith(color: disabledColor);
            }
            return border;
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          backgroundColor:
              WidgetStatePropertyAll(baseTheme.scaffoldBackgroundColor),
          foregroundColor: WidgetStatePropertyAll(onSurfaceColor),
          overlayColor: const WidgetStatePropertyAll(disabledColor),
          side: WidgetStatePropertyAll(BorderSide(color: onSurfaceColor)),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineWidth: const WidgetStatePropertyAll(1),
        trackOutlineColor: WidgetStatePropertyAll(onSurfaceColor),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.any((element) => (element == WidgetState.selected))) {
            if (states.any((element) => (element == WidgetState.disabled))) {
              return disabledColor;
            }
            return baseTheme.colorScheme.success;
          }
          return Colors.transparent;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.any((element) => (element == WidgetState.selected))) {
            return Colors.white;
          }
          if (states.any((element) => (element == WidgetState.disabled))) {
            return disabledColor;
          }
          return onSurfaceColor;
        }),
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
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
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
            color: onSurfaceColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(8, 5),
              topRight: Radius.elliptical(8, 5),
            ),
          ),
        ),
        indicatorColor: onSurfaceColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: onSurfaceColor,
        unselectedLabelColor: disabledColor,
        overlayColor: const WidgetStatePropertyAll(disabledColor),
      ),
    );
  }
}

extension CustomThemeValues on ColorScheme {
  Color get success =>
      brightness == Brightness.dark ? Colors.green : Colors.green.shade800;

  Color convertPlayerColor(PlayerColors color) {
    return brightness == Brightness.dark ? color.dark : color.light;
  }
}
