import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../theme/my_theme_colors.dart';

class LinesBackground extends StatelessWidget {
  const LinesBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinesPainter(
        colors: MyThemeColors.values
            .slice(0, 6)
            .map((color) => Theme.of(context).colorScheme.convertMyColor(color))
            .toList(),
      ),
      size: Size.infinite,
    );
  }
}

class LinesPainter extends CustomPainter {
  final List<Color> colors;

  static const double lineHeight = 12;
  static const double lineSpacing = 10;

  const LinesPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < colors.length; i++) {
      final spacing = i * (lineSpacing + lineHeight);
      final leftTopCorner = size.height / 1.75;
      final rightTopCorner = size.height / 3;

      final paint = Paint();
      paint.color = colors[i];

      final path = Path()
        ..moveTo(0, leftTopCorner + spacing)
        ..lineTo(size.width, rightTopCorner + spacing)
        ..lineTo(size.width, rightTopCorner + spacing + lineHeight)
        ..lineTo(0, leftTopCorner + spacing + lineHeight)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
