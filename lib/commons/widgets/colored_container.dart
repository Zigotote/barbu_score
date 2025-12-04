import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../theme/my_theme_colors.dart';

/// A container with a colored border
class ColoredContainer extends StatelessWidget {
  /// The alignment of the child of the container
  final Alignment? alignment;

  /// The height of the container
  final double? height;

  /// The width of the container, if not specified the width of the parent is used
  final double? width;

  /// The color to use for the border
  final MyThemeColors color;

  /// The child to put on the container
  final Widget child;

  const ColoredContainer({
    super.key,
    this.alignment = Alignment.bottomCenter,
    this.height,
    this.width,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Theme.of(context).colorScheme.convertMyColor(color),
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
