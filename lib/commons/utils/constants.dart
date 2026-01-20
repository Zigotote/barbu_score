import 'dart:io';

final bool kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

const int kNbPlayersMin = 3;
const int kNbPlayersMaxForOneDeck = 6;
const int kNbPlayersMax = 10;

const kNbTricksByRound = 8;
const kNbTricksByRoundByPlayer = {
  3: 10,
  4: 8,
  5: 6,
  6: 5,
  7: 7,
  8: 6,
  9: 10,
  10: 10,
}; // TODO Océane MAINTENANT essayer de plutôt demander la taille du deck plutôt que le nombre de plis par joueur
