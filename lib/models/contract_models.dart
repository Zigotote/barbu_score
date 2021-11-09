import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import 'contract_names.dart';

/// An abstract class to fill the scores for a contract
abstract class AbstractContractModel {
  /// The name of the contract
  final ContractsNames name;

  /// The scores of all the players for this contract
  Map<PlayerController, int> _scores;

  AbstractContractModel(this.name) {
    this._scores = {};
  }

  /// Sets the score of each player from a Map wich links all players with the number of tricks/cards they won.
  /// The players not present in the list have a score of 0.
  /// Returns true if the score has been set correctly, false if the trickByPlayer Map is not correctly filled
  bool setScores(Map<PlayerController, int> trickByPlayer);
}

/// An abstract class to fill the scores for a contract which has only one looser
abstract class AbstractOneLooserContractModel extends AbstractContractModel {
  /// The number of points the looser will have for this contract
  final int _points;

  AbstractOneLooserContractModel(ContractsNames name, this._points)
      : super(name);

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
  bool setScores(Map<PlayerController, int> trickByPlayer) {
    final int declaredItems = trickByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    if (declaredItems != this._expectedItems) {
      Get.snackbar(
        "Validation impossible",
        "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Il devrait y en avoir $_expectedItems.",
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
      return false;
    }
    if (trickByPlayer.keys.length == 1) {
      this._scores[trickByPlayer.entries.first.key] =
          0 - (this._expectedItems * this._pointsByItem);
    } else {
      trickByPlayer.forEach((player, value) {
        this._scores[player] = value * this._pointsByItem;
      });
    }
    Get.find<PartyController>().players.forEach(
          (player) => this._scores.putIfAbsent(player, () => 0),
        );
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
  bool setScores(Map<PlayerController, int> rankOfPlayer) {
    return false;
  }
}

/// A domino contract scores
class DominoContractModel extends AbstractContractModel {
  DominoContractModel() : super(ContractsNames.Domino);

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

    /// The scores the player can have (it is a symmetric array)
    List<int> scores = [40, 20, 10];
    double middleIndex = orderedPlayers.length / 2;
    orderedPlayers.forEach((player) {
      int score = 0;
      int playerIndex = orderedPlayers.indexOf(player);

      /// If the number of players is odd, and the player is in the middle rank, he has 0 points. Else it is calculated
      if (orderedPlayers.length % 2 == 0 || middleIndex - 0.5 != playerIndex) {
        /// The firsts players have a negative score, other have a positive score
        if (playerIndex < middleIndex) {
          score -= scores[playerIndex];
        } else {
          score = scores[orderedPlayers.length - playerIndex - 1];
        }
      }
      this._scores[player.key] = score;
    });
    return true;
  }
}
