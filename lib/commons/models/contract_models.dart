import 'dart:convert';

import '../utils/globals.dart' as globals;
import '../utils/storage.dart';
import 'contract_info.dart';
import 'domino_points_props.dart';

/// An abstract class to fill the scores for a contract
abstract class AbstractContractModel {
  /// Calculates the total score of each player, from a list of contracts
  static Map<String, int> calculateTotalScore(
      List<AbstractContractModel> contracts) {
    Map<String, int> playerScores = {};
    for (var contract in contracts) {
      contract.scores.forEach((player, score) {
        int? playerScore = playerScores[player];
        if (playerScore != null) {
          playerScores[player] = playerScore + score;
        } else {
          playerScores[player] = score;
        }
      });
    }
    return playerScores;
  }

  /// The name of the contract
  final String name;

  /// The scores of all the players for this contract
  late Map<String, int> _scores;

  AbstractContractModel(this.name) {
    _scores = {};
  }

  factory AbstractContractModel.fromJson(Map<String, dynamic> json) {
    AbstractContractModel abstractContractModel =
        ContractsInfo.getContractFromToString(json["name"]);
    abstractContractModel._scores = Map.castFrom(jsonDecode(json["scores"]));
    return abstractContractModel;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "scores": jsonEncode(_scores),
    };
  }

  Map<String, int> get scores => _scores;

  /// The number of item (or rank) of the players, calculated from _scores. Used to modify the contract.
  Map<String, int> get playerItems;

  /// Sets the score of each player from a Map wich links all player's names with the number of tricks/cards they won.
  /// Returns true if the score has been set correctly, false if the trickByPlayer Map is not correctly filled
  bool setScores(Map<String, int> itemsByPlayer);
}

/// A class to fill the scores for a contract which has only one looser
class OneLooserContractModel extends AbstractContractModel {
  /// The number of points the looser will have for this contract
  final int _points;

  OneLooserContractModel(ContractsInfo contractsInfo)
      : _points = MyStorage().getPoints(contractsInfo),
        super(contractsInfo.name);

  @override
  Map<String, int> get playerItems => {
        for (var playerScore in scores.entries)
          playerScore.key: playerScore.value == _points ? 1 : 0
      };

  /// Sets the score of the player in the Map at the value of this.points. Other players have a score of 0.
  /// Returns true if the score has been set correctly, false otherwise (less or more than 1 player in the Map)
  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    if (itemsByPlayer.entries.isEmpty) {
      return false;
    }
    _scores = itemsByPlayer.map(
      (playerName, nbItems) => MapEntry(playerName, nbItems * _points),
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
    ContractsInfo contractsInfo,
    this._expectedItems,
  )   : _pointsByItem = MyStorage().getPoints(contractsInfo),
        super(contractsInfo.name);

  /// Returns the maximal score for the contract
  int get expectedItems => _expectedItems;

  @override
  Map<String, int> get playerItems => {
        for (var playerScore in scores.entries)
          playerScore.key: ((playerScore.value) ~/ _pointsByItem).abs()
      };

  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    if (declaredItems != _expectedItems) {
      return false;
    }
    try {
      MapEntry<String, int> playerWithNegativeScore = itemsByPlayer.entries
          .firstWhere((playerItems) => playerItems.value == _expectedItems);
      _scores[playerWithNegativeScore.key] =
          0 - (_expectedItems * _pointsByItem);
      itemsByPlayer.forEach(
        (player, items) => _scores.putIfAbsent(player, () => 0),
      );
    } catch (_) {
      itemsByPlayer.forEach((player, value) {
        _scores[player] = value * _pointsByItem;
      });
    }
    return true;
  }
}

/// A no hearts contract scores
class NoHeartsContractModel extends AbstractMultipleLooserContractModel {
  NoHeartsContractModel()
      : super(ContractsInfo.noHearts, globals.nbPlayers * 2);
}

/// A no queens contract scores
class NoQueensContractModel extends AbstractMultipleLooserContractModel {
  NoQueensContractModel() : super(ContractsInfo.noQueens, 4);
}

/// A no tricks contract scores
class NoTricksContractModel extends AbstractMultipleLooserContractModel {
  NoTricksContractModel() : super(ContractsInfo.noTricks, 8);
}

/// A trumps contract scores
class TrumpsContractModel extends AbstractContractModel {
  TrumpsContractModel() : super(ContractsInfo.trumps.name);

  @override
  Map<String, int> get playerItems => {};

  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    _scores = itemsByPlayer;
    return true;
  }
}

/// A domino contract scores
class DominoContractModel extends AbstractContractModel {
  /// The scores the player can have
  final DominoPointsProps _dominoPointsProps = MyStorage().getDominoPoints();

  DominoContractModel() : super(ContractsInfo.domino.name);

  @override
  Map<String, int> get playerItems {
    List<MapEntry<String, int>> sortedList = scores.entries.toList();
    sortedList.sort((a, b) => a.value.compareTo(b.value));
    return {
      for (var playerScore in sortedList)
        playerScore.key: sortedList.indexOf(playerScore)
    };
  }

  /// Sets the score of each player from a Map wich links each player with its rank
  @override
  bool setScores(Map<String, int> rankOfPlayer) {
    if (rankOfPlayer.isEmpty) {
      return false;
    }
    List<MapEntry<String, int>> orderedPlayers = rankOfPlayer.entries.toList();
    orderedPlayers.sort(
      (element1, element2) => element1.value - element2.value,
    );

    final List<int> dominoPoints = _dominoPointsProps.points;
    final double middleIndex = orderedPlayers.length / 2;
    for (var player in orderedPlayers) {
      int playerIndex = orderedPlayers.indexOf(player);

      if (_dominoPointsProps.isFix) {
        _scores[player.key] = dominoPoints[playerIndex];
      } else {
        int score = 0;
        // If the number of players is odd, and the player is in the middle rank, he has 0 points. Else it is calculated
        if (orderedPlayers.length % 2 == 0 ||
            middleIndex - 0.5 != playerIndex) {
          // To get the first players scores, we read the array forward
          if (playerIndex < middleIndex) {
            score = dominoPoints[playerIndex];
          }
          // To get the last players scores, the array is read backward
          else {
            score = dominoPoints[
                dominoPoints.length - (orderedPlayers.length - playerIndex)];
          }
        }
        _scores[player.key] = score;
      }
    }
    return true;
  }
}
