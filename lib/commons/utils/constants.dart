import 'dart:io';

final bool kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

const int kNbPlayersMin = 3;
const int kNbPlayersMaxForOneDeck = 6;
const int kNbPlayersMax = 10;
