import 'package:flutter/material.dart';

class Player {
  /// The color of the player
  Color color;

  /// The image of the player
  String image;

  /// The name of the player
  String? name;

  Player({required this.color, required this.image, this.name});
}
