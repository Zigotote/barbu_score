import 'dart:collection';

import 'package:get/get.dart';

import '../main.dart';
import '../models/contract_names.dart';
import 'player.dart';

/// A party with some players
class PartyController extends GetxController {
  /// The list of the players for this party
  RxList<PlayerController> _players;

  /// The index of the current player
  int _currentPlayerIndex;

  PartyController(List players) {
    this._players = List<PlayerController>.from(players).obs;
    _currentPlayerIndex = 0;
  }

  /// Returns the player list
  UnmodifiableListView<PlayerController> get players =>
      UnmodifiableListView(_players);

  /// Returns the number of players for the party
  int get nbPlayers => _players.length;

  /// Returns the current player
  PlayerController get currentPlayer => _players[_currentPlayerIndex];

  /// Saves the score for the contract and changes the current player to the next one
  void finishContract(
      ContractsNames contract, Map<PlayerController, int> playerScores) {
    final bool isValidScore =
        this.currentPlayer.addContract(contract, playerScores);
    if (isValidScore) {
      this._nextPlayer();
    } else {
      Get.snackbar(
        "Scores incorrects",
        "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.",
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
    }
  }

  /// Changes the current player to the next one
  /// Navigates to the next page (choose contract if their is at least one left, lefts the party otherwise)
  void _nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == this.nbPlayers) {
      _currentPlayerIndex = 0;
    }
    if (this.currentPlayer.availableContracts.length > 0) {
      Get.toNamed(Routes.CHOOSE_CONTRACT);
    } else {
      Get.toNamed(Routes.HOME);
    }
  }
}
