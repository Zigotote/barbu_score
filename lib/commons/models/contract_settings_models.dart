import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/globals.dart';
import 'contract_info.dart';

part 'contract_settings_models.g.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings with EquatableMixin {
  /// The indicator to know if the user wants to have this contract in its games or not
  @HiveField(0)
  bool isActive;

  AbstractContractSettings({this.isActive = true});

  /// Fills the rules depending on the contract settings
  String filledRules(String rules);

  /// Copies the object with some overrides
  AbstractContractSettings copy();
}

/// A class to save the settings for a contract where an item has points
@HiveType(typeId: 9)
class PointsContractSettings extends AbstractContractSettings {
  /// The points for this contract item
  @HiveField(1)
  int points;

  PointsContractSettings({super.isActive, required this.points});

  @override
  String filledRules(String rules) {
    return sprintf(rules, [points]);
  }

  @override
  PointsContractSettings copy() {
    return PointsContractSettings(isActive: isActive, points: points);
  }

  @override
  List<Object?> get props => [isActive, points];
}

/// A class to save the settings for a contract where multiple players can have some points
@HiveType(typeId: 10)
class IndividualScoresContractSettings extends PointsContractSettings {
  /// The indicator to know if the score should be inverted if one players wins all contract items
  @HiveField(2)
  bool invertScore;

  IndividualScoresContractSettings(
      {super.isActive, required super.points, this.invertScore = true});

  @override
  String filledRules(String rules) {
    String invertScoreSentence = "";
    if (invertScore) {
      invertScoreSentence =
          " Si un joueur remporte tout, son score devient négatif.";
    }
    return super.filledRules(rules) + invertScoreSentence;
  }

  @override
  IndividualScoresContractSettings copy() {
    return IndividualScoresContractSettings(
      isActive: isActive,
      points: points,
      invertScore: invertScore,
    );
  }

  @override
  List<Object?> get props => [isActive, points, invertScore];
}

/// A trumps contract settings
@HiveType(typeId: 11)
class TrumpsContractSettings extends AbstractContractSettings {
  /// Lists all contract that could be part of a trumps contract
  static List<ContractsInfo> availableContracts = ContractsInfo.values
      .where((contract) =>
          contract != ContractsInfo.trumps && contract != ContractsInfo.domino)
      .toList();

  /// A map to know if each contract should be part of trumps contract or not
  @HiveField(1)
  final Map<ContractsInfo, bool> contracts;

  TrumpsContractSettings({super.isActive, required this.contracts});

  @override
  String filledRules(String rules) {
    return sprintf(rules, [
      contracts.entries
          .where((contract) => contract.value)
          .toList()
          .map((e) => e.key.displayName.toLowerCase().replaceAll("sans ", ""))
          .toString()
          .replaceAll('(', "")
          .replaceAll(')', "")
    ]);
  }

  @override
  TrumpsContractSettings copy() {
    return TrumpsContractSettings(isActive: isActive, contracts: contracts);
  }

  @override
  List<Object?> get props => [isActive, contracts];
}

/// A domino contract settings
@HiveType(typeId: 12)
class DominoContractSettings extends AbstractContractSettings {
  /// The points for each player rank, depending on the number of player in the game
  @HiveField(1)
  late Map<int, List<int>> points;

  DominoContractSettings({
    super.isActive,
    int? pointsFirstPlayer,
    int? pointsLastPlayer,
    Map<int, List<int>>? points,
  })  : assert((pointsLastPlayer != null && pointsFirstPlayer != null) ||
            points != null),
        super() {
    this.points =
        points ?? generatePointsLists(pointsFirstPlayer!, pointsLastPlayer!);
  }

  /// Generates points lists depending on number players in the game
  Map<int, List<int>> generatePointsLists(
      int pointsFirstPlayer, int pointsLastPlayer) {
    return Map.fromIterable(
      List.generate(
        kNbPlayersMax - kNbPlayersMin + 1,
        (index) => index + kNbPlayersMin,
      ),
      value: (key) => calculatePoints(key, pointsFirstPlayer, pointsLastPlayer),
    );
  }

  /// Returns the points of each player depending on min and max value
  @visibleForTesting
  List<int> calculatePoints(
      int nbPlayers, int pointsFirstPlayer, int pointsLastPlayer) {
    final double middleIndex = nbPlayers / 2;
    int pointsByPart =
        (pointsLastPlayer - pointsFirstPlayer) ~/ (nbPlayers - 1);

    if (pointsByPart % 10 != 0 && nbPlayers % 2 == 0) {
      pointsByPart =
          ((pointsLastPlayer - pointsFirstPlayer) / 2) ~/ middleIndex;
    }
    return List.generate(nbPlayers, (index) {
      var points = 0;
      if (index == 0) {
        return pointsFirstPlayer;
      }
      if (index == nbPlayers - 1) {
        return pointsLastPlayer;
      }

      // To get the first players scores, we add values to min points
      if (index < middleIndex) {
        points = pointsFirstPlayer + (pointsByPart * index);
      }
      // To get the last players scores, we subtract values to max points
      else {
        points = pointsLastPlayer - pointsByPart * (nbPlayers - index - 1);
      }

      if (points < min(pointsLastPlayer, pointsFirstPlayer)) {
        points = min(pointsLastPlayer, pointsFirstPlayer);
      } else if (points > max(pointsLastPlayer, pointsFirstPlayer)) {
        points = max(pointsFirstPlayer, pointsLastPlayer);
      }
      // Rounds the value to the nearest 10
      return points ~/ 10 * 10;
    });
  }

  @override
  String filledRules(String rules) {
    return rules;
  }

  @override
  DominoContractSettings copy() {
    return DominoContractSettings(isActive: isActive, points: points);
  }

  @override
  List<Object?> get props => [isActive, points];
}
