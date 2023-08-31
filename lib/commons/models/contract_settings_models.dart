import 'dart:math';

import 'package:hive/hive.dart';

import 'contract_info.dart';

part 'contract_settings_models.g.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings {
  /// The indicator to know if the user wants to have this contract in its games or not
  @HiveField(0)
  bool isActive;

  AbstractContractSettings({this.isActive = true});
}

/// A class to save the settings for a contract where an item has points
@HiveType(typeId: 9)
class PointsContractSettings extends AbstractContractSettings {
  /// The points for this contract item
  @HiveField(1)
  int points;

  PointsContractSettings({required this.points});
}

/// A class to save the settings for a contract where multiple players can have some points
@HiveType(typeId: 10)
class IndividualScoresContractSettings extends PointsContractSettings {
  /// The indicator to know if the score should be inverted if one players wins all contract items
  @HiveField(2)
  bool invertScore;

  IndividualScoresContractSettings(
      {required super.points, this.invertScore = true});
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

  TrumpsContractSettings({required this.contracts}) : super();
}

/// A domino contract settings
@HiveType(typeId: 12)
class DominoContractSettings extends AbstractContractSettings {
  /// The points the best player will have
  @HiveField(1)
  int pointsFirstPlayer;

  /// The points the worst player will have
  @HiveField(2)
  int pointsLastPlayer;

  DominoContractSettings(
      {required this.pointsFirstPlayer, required this.pointsLastPlayer})
      : super();

  /// Returns the points of each player depending on min and max value
  List<int> calculatePoints(int nbPlayers) {
    final double middleIndex = nbPlayers / 2;
    int pointsByPart =
        (pointsLastPlayer - pointsFirstPlayer) ~/ (nbPlayers - 1);

    if (pointsByPart % 10 != 0) {
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
      if (nbPlayers % 2 == 0 || middleIndex - 0.5 != index) {
        // To get the first players scores, we add values to min points
        if (index < middleIndex) {
          points = pointsFirstPlayer + (pointsByPart * index);
        }
        // To get the last players scores, we subtract values to max points
        else {
          points = pointsLastPlayer - pointsByPart * (nbPlayers - index - 1);
        }
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
}
