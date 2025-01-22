/// Returns the values of the cards to take out for the game
List<int> getCardsToTakeOut(int nbPlayers) {
  return List.generate((52 - nbPlayers * 8) ~/ 4, (index) => 2 + index);
}
