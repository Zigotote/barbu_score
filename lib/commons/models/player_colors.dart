import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'player_colors.g.dart';

/// The colors available for players
@HiveType(typeId: 14)
enum PlayerColors {
  @HiveField(0)
  brown,
  @HiveField(1)
  green,
  @HiveField(2)
  yellow,
  @HiveField(3)
  orange,
  @HiveField(4)
  red,
  @HiveField(5)
  blue;

  const PlayerColors();

  Color get light {
    switch (this) {
      case PlayerColors.brown:
        return Colors.brown.shade700;
      case PlayerColors.green:
        return Colors.lightGreen.shade900;
      case PlayerColors.yellow:
        return Colors.yellow.shade800;
      case PlayerColors.orange:
        return Colors.orange.shade800;
      case PlayerColors.red:
        return Colors.deepOrange.shade900;
      case PlayerColors.blue:
        return Colors.teal.shade900;
    }
  }

  Color get dark {
    switch (this) {
      case PlayerColors.brown:
        return Colors.brown.shade400;
      case PlayerColors.green:
        return Colors.lightGreen.shade800;
      case PlayerColors.yellow:
        return Colors.yellow.shade700;
      case PlayerColors.orange:
        return Colors.orange.shade800;
      case PlayerColors.red:
        return Colors.deepOrange.shade700;
      case PlayerColors.blue:
        return Colors.teal.shade400;
    }
  }

  /// Returns the PlayerColors associated to the color
  static PlayerColors fromValue(Color color) {
    return PlayerColors.values.firstWhere((playerColor) =>
        playerColor.light == color || playerColor.dark == color);
  }
}
