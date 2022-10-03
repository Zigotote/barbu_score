import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../utils/snackbar.dart';
import 'contract_names.dart';

/// An abstract class to fill the scores for a contract
abstract class AbstractContractModel {
  /// Calculates the total score of each player, from a list of contracts
  static Map<PlayerController, int> calculateTotalScore(
      List<AbstractContractModel> contracts) {
    Map<PlayerController, int> playerScores = {};
    contracts.forEach((contract) {
      contract.scores.forEach((player, score) {
        if (playerScores.containsKey(player)) {
          playerScores[player] += score;
        } else {
          playerScores[player] = score;
        }
      });
    });
    return playerScores;
  }

  /// The name of the contract
  final ContractsNames name;

  /// The scores of all the players for this contract
  Map<PlayerController, int> _scores;

  AbstractContractModel(this.name) {
    this._scores = {};
  }

  AbstractContractModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        _scores = json["scores"];

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "scores": _scores,
    };
  }

  Map<PlayerController, int> get scores => _scores;

  /// The number of item (or rank) of the players, calculated from _scores. Used to modify the contract.
  Map<PlayerController, int> get playerItems;

  /// Sets the score of each player from a Map wich links all players with the number of tricks/cards they won.
  /// The players not present in the list have a score of 0.
  /// Returns true if the score has been set correctly, false if the trickByPlayer Map is not correctly filled
  bool setScores(Map<PlayerController, int> playerItems);
}

/// An abstract class to fill the scores for a contract which has only one looser
abstract class AbstractOneLooserContractModel extends AbstractContractModel {
  /// The number of points the looser will have for this contract
  final int _points;

  AbstractOneLooserContractModel(ContractsNames name, this._points)
      : super(name);

  @override
  Map<PlayerController, int> get playerItems => Map.fromIterable(
        scores.entries,
        key: (playerScore) => playerScore.key,
        value: (playerScore) => playerScore.value == _points ? 1 : 0,
      );

  /// Sets the score of the player in the Map at the value of this.points. Other players have a score of 0.
  /// Returns true if the score has been set correctly, false otherwise (less or more than 1 player in the Map)
  @override
  bool setScores(Map<PlayerController, int> trickByPlayer) {
    if (trickByPlayer.entries.length != 1) {
      return false;
    }
    this._scores[trickByPlayer.entries.first.key] = this._points;
    Get.find<PartyController>().players.forEach(
          (player) => this._scores.putIfAbsent(player, () => 0),
        );
    return true;
  }
}

/// An abstract class to fill the scores for a contract where multiple players can have some points
abstract class AbstractMultipleLooserContractModel
    extends AbstractContractModel {
  /// The number of points each item (card or trick) costs
  final int _pointsByItem;

  /// The number of item (card or trick) the deck should have
  final int _expectedItems;

  AbstractMultipleLooserContractModel(
    ContractsNames name,
    this._pointsByItem,
    this._expectedItems,
  ) : super(name);

  /// Returns the maximal score for the contract
  int get expectedItems => _expectedItems;

  @override
  Map<PlayerController, int> get playerItems => Map.fromIterable(
        scores.entries,
        key: (playerScore) => playerScore.key,
        value: (playerScore) =>
            ((playerScore.value as int) ~/ this._pointsByItem).abs(),
      );

  @override
  bool setScores(Map<PlayerController, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    if (declaredItems != this._expectedItems) {
      SnackbarUtils.openSnackbar(
        "Validation impossible",
        "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Il devrait y en avoir $_expectedItems.",
      );
      return false;
    }
    MapEntry<PlayerController, int> playerWithNegativeScore = itemsByPlayer
        .entries
        .firstWhere((playerItems) => playerItems.value == this._expectedItems,
            orElse: () => null);
    if (playerWithNegativeScore != null) {
      this._scores[playerWithNegativeScore.key] =
          0 - (this._expectedItems * this._pointsByItem);
      itemsByPlayer.forEach(
        (player, items) => this._scores.putIfAbsent(player, () => 0),
      );
    } else {
      itemsByPlayer.forEach((player, value) {
        this._scores[player] = value * this._pointsByItem;
      });
    }
    return true;
  }
}

/// A barbu contract scores
class BarbuContractModel extends AbstractOneLooserContractModel {
  BarbuContractModel() : super(ContractsNames.Barbu, 50);
}

/// A no hearts contract scores
class NoHeartsContractModel extends AbstractMultipleLooserContractModel {
  NoHeartsContractModel()
      : super(
          ContractsNames.NoHearts,
          5,
          Get.find<PartyController>().nbPlayers * 2,
        );
}

/// A no queens contract scores
class NoQueensContractModel extends AbstractMultipleLooserContractModel {
  NoQueensContractModel() : super(ContractsNames.NoQueens, 10, 4);
}

/// A no tricks contract scores
class NoTricksContractModel extends AbstractMultipleLooserContractModel {
  NoTricksContractModel() : super(ContractsNames.NoTricks, 5, 8);
}

/// A no last trick contract scores
class NoLastTrickContractModel extends AbstractOneLooserContractModel {
  NoLastTrickContractModel() : super(ContractsNames.NoLastTrick, 40);
}

/// A trumps contract scores
class TrumpsContractModel extends AbstractContractModel {
  TrumpsContractModel() : super(ContractsNames.Trumps);

  @override
  Map<PlayerController, int> get playerItems => {};

  @override
  bool setScores(Map<PlayerController, int> playerScores) {
    this._scores = playerScores;
    return true;
  }
}

/// A domino contract scores
class DominoContractModel extends AbstractContractModel {
  /// The scores the player can have (it is a symmetric array)
  final List<int> _rankScores = [40, 20, 10];

  DominoContractModel() : super(ContractsNames.Domino);

  @override
  Map<PlayerController, int> get playerItems {
    List<MapEntry<PlayerController, int>> sortedList = scores.entries.toList();
    sortedList.sort((a, b) => a.value.compareTo(b.value));
    return Map.fromIterable(
      sortedList,
      key: (playerScore) => playerScore.key,
      value: (playerScore) => sortedList.indexOf(playerScore),
    );
  }

  /// Sets the score of each player from a Map wich links each player with its rank
  @override
  bool setScores(Map<PlayerController, int> rankOfPlayer) {
    if (rankOfPlayer.length != Get.find<PartyController>().nbPlayers) {
      return false;
    }
    List<MapEntry<PlayerController, int>> orderedPlayers =
        rankOfPlayer.entries.toList();
    orderedPlayers.sort(
      (element1, element2) => element1.value - element2.value,
    );

    double middleIndex = orderedPlayers.length / 2;
    orderedPlayers.forEach((player) {
      int score = 0;
      int playerIndex = orderedPlayers.indexOf(player);

      /// If the number of players is odd, and the player is in the middle rank, he has 0 points. Else it is calculated
      if (orderedPlayers.length % 2 == 0 || middleIndex - 0.5 != playerIndex) {
        /// The firsts players have a negative score, other have a positive score
        if (playerIndex < middleIndex) {
          score -= this._rankScores[playerIndex];
        } else {
          score = this._rankScores[orderedPlayers.length - playerIndex - 1];
        }
      }
      this._scores[player.key] = score;
    });
    return true;
  }
}
