import 'dart:io';

final bool kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

const int kNbPlayersMin = 3;
const int kNbPlayersMax = 6;
const String kPlayerImageFolder = "assets/players/player%s.png";
