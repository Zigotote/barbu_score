import 'package:flutter/material.dart';

/// The colors available for players
enum PlayerColors {
  brown,
  green,
  yellow,
  orange,
  red,
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

  /// Returns the PlayerColors from its name
  static PlayerColors fromName(String name) {
    return PlayerColors.values.firstWhere((color) => color.name == name);
  }
}
