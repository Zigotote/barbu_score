import 'package:hive/hive.dart';

import '../utils/globals.dart' as globals;
import '../utils/storage.dart';
import 'contract_info.dart';
import 'contract_settings_models.dart';

part 'contract_models.g.dart';

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

  /// The contract associated to this model
  final ContractsInfo contract;

  /// The name of the contract
  @HiveField(0)
  final String name;

  /// The scores of all the players for this contract
  @HiveField(1)
  Map<String, int> _scores;

  AbstractContractModel(this.contract)
      : name = contract.name,
        _scores = {};

  /// The settings associated to this contract
  AbstractContractSettings get _settings => MyStorage.getSettings(contract);

  Map<String, int> get scores => _scores;

  /// The number of item (or rank) of the players, calculated from _scores. Used to modify the contract.
  Map<String, int> get playerItems;

  /// Sets the score of each player from a Map wich links all player's names with the number of tricks/cards they won.
  /// Returns true if the score has been set correctly, false if the trickByPlayer Map is not correctly filled
  bool setScores(Map<String, int> itemsByPlayer);

  @override
  String toString() {
    return "$name : $_scores";
  }
}

/// A class to fill the scores for a contract which has only one looser
abstract class OneLooserContractModel extends AbstractContractModel {
  OneLooserContractModel(super.contract);

  @override
  Map<String, int> get playerItems => {
        for (var playerScore in scores.entries)
          playerScore.key: playerScore.value != 0 ? 1 : 0
      };

  /// Sets the score of the player in the Map at the value of this.points. Other players have a score of 0.
  /// Returns true if the score has been set correctly, false otherwise (less or more than 1 player in the Map)
  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    if (itemsByPlayer.entries.isEmpty) {
      return false;
    }
    _scores = itemsByPlayer.map(
      (playerName, nbItems) => MapEntry(
          playerName, nbItems * (_settings as PointsContractSettings).points),
    );
    return true;
  }
}

/// An abstract class to fill the scores for a contract where multiple players can have some points
abstract class AbstractMultipleLooserContractModel
    extends AbstractContractModel {
  /// The number of item (card or trick) the deck should have
  final int _expectedItems;

  AbstractMultipleLooserContractModel(
    super.contract,
    this._expectedItems,
  );

  /// Returns the maximal score for the contract
  int get expectedItems => _expectedItems;

  @override
  Map<String, int> get playerItems => {
        for (var playerScore in scores.entries)
          playerScore.key: ((playerScore.value) ~/
                  (_settings as IndividualScoresContractSettings).points)
              .abs()
      };

  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    if (declaredItems != _expectedItems) {
      return false;
    }
    final settings = _settings as IndividualScoresContractSettings;
    try {
      MapEntry<String, int>? playerWithAllItems = itemsByPlayer.entries
          .firstWhere((playerItems) => playerItems.value == _expectedItems);
      int score = _expectedItems * settings.points;
      if (settings.invertScore) {
        score = -score;
      }
      _scores[playerWithAllItems.key] = score;
      itemsByPlayer.forEach(
        (player, items) => _scores.putIfAbsent(player, () => 0),
      );
    } catch (_) {
      itemsByPlayer.forEach((player, value) {
        _scores[player] = value * settings.points;
      });
    }
    return true;
  }
}

/// A barbu contract scores
@HiveType(typeId: 2)
class BarbuContractModel extends OneLooserContractModel {
  BarbuContractModel() : super(ContractsInfo.barbu);
}

/// A no last trick contract scores
@HiveType(typeId: 3)
class NoLastTrickContractModel extends OneLooserContractModel {
  NoLastTrickContractModel() : super(ContractsInfo.noLastTrick);
}

/// A no hearts contract scores
@HiveType(typeId: 4)
class NoHeartsContractModel extends AbstractMultipleLooserContractModel {
  NoHeartsContractModel()
      : super(ContractsInfo.noHearts, globals.nbPlayers * 2);
}

/// A no queens contract scores
@HiveType(typeId: 5)
class NoQueensContractModel extends AbstractMultipleLooserContractModel {
  NoQueensContractModel() : super(ContractsInfo.noQueens, 4);
}

/// A no tricks contract scores
@HiveType(typeId: 6)
class NoTricksContractModel extends AbstractMultipleLooserContractModel {
  NoTricksContractModel() : super(ContractsInfo.noTricks, 8);
}

/// A trumps contract scores
@HiveType(typeId: 7)
class TrumpsContractModel extends AbstractContractModel {
  TrumpsContractModel() : super(ContractsInfo.trumps);

  @override
  Map<String, int> get playerItems => {};

  @override
  bool setScores(Map<String, int> itemsByPlayer) {
    _scores = itemsByPlayer;
    return true;
  }
}

/// A domino contract scores
@HiveType(typeId: 8)
class DominoContractModel extends AbstractContractModel {
  DominoContractModel() : super(ContractsInfo.domino);

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
    List<int> points =
        (_settings as DominoContractSettings).points[globals.nbPlayers]!;
    _scores =
        rankOfPlayer.map((player, rank) => MapEntry(player, points[rank]));
    return true;
  }
}
