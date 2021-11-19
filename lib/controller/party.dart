import 'dart:collection';

import 'package:get/get.dart';

import './player.dart';
import '../main.dart';
import '../models/contract_names.dart';
import '../models/route_argument.dart';
import '../utils/snackbar.dart';

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

  /// Returns the player list ordered by score
  UnmodifiableListView<PlayerController> get orderedPlayers {
    List<MapEntry<PlayerController, int>> orderedPlayers =
        playerScores.entries.toList();
    orderedPlayers
        .sort((player1, player2) => player1.value.compareTo(player2.value));
    return UnmodifiableListView(orderedPlayers.map((player) => player.key));
  }

  /// Returns the number of players for the party
  int get nbPlayers => _players.length;

  /// Returns the current player
  PlayerController get currentPlayer => _players[_currentPlayerIndex];

  /// Returns the total score of each player for the party
  Map<PlayerController, int> get playerScores {
    Map<PlayerController, int> playerScores = Map.fromIterable(
      _players,
      key: (player) => player,
      value: (_) => 0,
    );
    _players.forEach((p) {
      p.playerScores.forEach((player, score) {
        playerScores[player] += score;
      });
    });
    return playerScores;
  }

  /// Saves the score for the contract and changes the current player to the next one
  void finishContract(
      ContractsNames contract, Map<PlayerController, int> playerScores) {
    final bool isValidScore =
        this.currentPlayer.addContract(contract, playerScores);
    if (isValidScore) {
      /// If the contract scores has been modified, we got back to the choose contract score
      /// Else, it goes to the next player
      if ((Get.arguments as RouteArgument).isForModification) {
        Get.toNamed(Routes.CHOOSE_CONTRACT);
      } else {
        this._nextPlayer();
      }
    } else {
      SnackbarUtils.openSnackbar(
        "Scores incorrects",
        "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.",
      );
    }
  }

  /// Finds the player's best friend
  PlayerController bestFriend(PlayerController player) {
    return this._findPlayerWhere(player, (score1, score2) => score1 > score2);
  }

  /// Finds the player's worst ennemy
  PlayerController worstEnnemy(PlayerController player) {
    return this._findPlayerWhere(player, (score1, score2) => score1 < score2);
  }

  /// Finds the player's best friend
  PlayerController _findPlayerWhere(
      PlayerController player, Function(int, int) condition) {
    int score = player.playerScores[player];
    PlayerController playerFound = player;
    this._players.forEach((p) {
      final int playerScore = p.playerScores[player];
      if (condition(score, playerScore)) {
        playerFound = p;
        score = playerScore;
      }
    });
    return playerFound;
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
      Get.toNamed(Routes.FINISH_PARTY);
    }
  }
}
