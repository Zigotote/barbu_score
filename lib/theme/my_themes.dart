import 'package:flutter/material.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

import '../commons/models/player_colors.dart';

class MyThemes {
  MyThemes._();

  static final light = _baseTheme(ThemeData.light());

  static final dark = _baseTheme(ThemeData.dark());

  static _baseTheme(ThemeData baseTheme) {
    final onSurfaceColor = baseTheme.colorScheme.onSurface;
    final grey = baseTheme.colorScheme.grey;
    final disabledColor = baseTheme.brightness == Brightness.dark
        ? const Color(0xffAFAFAF)
        : const Color(0xff757575);

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
        primary: onSurfaceColor,
      ),
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 16),
        titleMedium: textTheme.titleMedium?.copyWith(fontSize: 18),
      ),
      dialogBackgroundColor: baseTheme.scaffoldBackgroundColor,
      disabledColor: disabledColor,
      dividerColor: onSurfaceColor,
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        textStyle: textTheme.bodyMedium,
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
            textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
          iconColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor;
            }
            return onSurfaceColor;
          }),
          backgroundColor:
              WidgetStatePropertyAll(baseTheme.scaffoldBackgroundColor),
          overlayColor: WidgetStatePropertyAll(grey),
          elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return 0;
            }
            return 10;
          }),
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
              border = border.copyWith(color: disabledColor, width: 1);
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
          overlayColor: WidgetStatePropertyAll(grey),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: onSurfaceColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: onSurfaceColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowEnterRouteSnapshotting: false,
          ),
        },
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
        overlayColor: WidgetStatePropertyAll(grey),
      ),
    );
  }
}

extension CustomThemeValues on ColorScheme {
  Color get grey => const Color(0xffafafaf);

  Color get success =>
      brightness == Brightness.dark ? Colors.green : Colors.green.shade800;

  Color convertPlayerColor(PlayerColors color) {
    return brightness == Brightness.dark ? color.dark : color.light;
  }
}
