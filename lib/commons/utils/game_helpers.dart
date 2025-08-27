import 'package:collection/collection.dart';

import 'constants.dart';

/// Returns the values of the cards to keep for the game
List<int> getCardsToKeep(int nbPlayers) {
  final cardIndexes = List.generate(13, (index) => index + 2).reversed.toList();

  int nbDeck = 1;
  if (nbPlayers > kNbPlayersMaxForOneDeck) {
    nbDeck = 2;
  }

  return cardIndexes.slice(0, ((nbPlayers * 8) / (4 * nbDeck)).toInt());
}

/// Returns the number of decks required for this number of players
int getNbDecks(int nbPlayers) {
  return nbPlayers <= kNbPlayersMaxForOneDeck ? 1 : 2;
}
