import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils/constants.dart';
import 'contract_info.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings with EquatableMixin {
  /// The name of the contract
  final String name;

  /// The indicator to know if the user wants to have this contract in its games or not
  bool isActive;

  AbstractContractSettings(
      {this.isActive = true, ContractsInfo? contract, String? name})
      : assert(name == null || contract == null,
            "Only name or contract should be used"),
        name = name ?? contract?.name ?? ""; // Fallback for app update

  factory AbstractContractSettings.fromJson(Map<String, dynamic> json) {
    final contract = ContractsInfo.fromName(json["name"]);
    final isActive = json["isActive"];
    return switch (contract) {
      ContractsInfo.barbu ||
      ContractsInfo.noLastTrick =>
        OneLooserContractSettings.fromJson(
          json,
          contract: contract,
          isActive: isActive,
        ),
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks =>
        MultipleLooserContractSettings.fromJson(
          json,
          contract: contract,
          isActive: isActive,
        ),
      ContractsInfo.salad => SaladContractSettings.fromJson(
          json,
          contract: contract,
          isActive: isActive,
        ),
      ContractsInfo.domino => DominoContractSettings.fromJson(
          json,
          contract: contract,
          isActive: isActive,
        )
    };
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "isActive": isActive};
  }

  /// Copies the object with some overrides
  AbstractContractSettings copy();

  @override
  List<Object?> get props => [name, isActive];
}

/// A class to save the settings for a contract where only one player can loose
class OneLooserContractSettings extends AbstractContractSettings {
  /// The points for this contract item
  int points;

  OneLooserContractSettings({
    super.contract,
    super.name,
    super.isActive,
    required this.points,
  });

  OneLooserContractSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : points = json["points"],
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "points": points};
  }

  @override
  List<Object?> get props => [...super.props, points];

  @override
  OneLooserContractSettings copy() {
    return OneLooserContractSettings(
      name: name,
      isActive: isActive,
      points: points,
    );
  }
}

/// A class to save the settings for a contract where multiple players can have some points
class MultipleLooserContractSettings extends AbstractContractSettings {
  /// The points for one item
  int points;

  /// The indicator to know if the score should be inverted if one players wins all contract items
  bool invertScore;

  MultipleLooserContractSettings({
    super.contract,
    super.name,
    super.isActive,
    required this.points,
    this.invertScore = true,
  });

  MultipleLooserContractSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : points = json["points"],
        invertScore = json["invertScore"],
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "points": points, "invertScore": invertScore};
  }

  @override
  List<Object?> get props => [...super.props, points, invertScore];

  @override
  MultipleLooserContractSettings copy() {
    return MultipleLooserContractSettings(
      name: name,
      isActive: isActive,
      points: points,
      invertScore: invertScore,
    );
  }
}

/// A salad contract settings
class SaladContractSettings extends AbstractContractSettings {
  /// Lists all contract that could be part of a salad contract
  static List<ContractsInfo> availableContracts = ContractsInfo.values
      .where((contract) =>
          contract != ContractsInfo.salad && contract != ContractsInfo.domino)
      .toList();

  /// A map to know if each contract should be part of salad contract or not
  final Map<String, bool> contracts;

  /// The indicator to know if the score should be inverted if one players wins all tricks
  bool invertScore;

  SaladContractSettings(
      {super.isActive, required this.contracts, this.invertScore = false})
      : super(contract: ContractsInfo.salad);

  SaladContractSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : contracts = Map.castFrom(jsonDecode(json["contracts"])),
        invertScore = json["invertScore"] ?? false,
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "contracts": jsonEncode(contracts),
      "invertScore": invertScore,
    };
  }

  /// Returns the active contracts
  List<ContractsInfo> get activeContracts => contracts.entries
      .where((contract) => contract.value)
      .map((contract) => ContractsInfo.fromName(contract.key))
      .toList();

  @override
  SaladContractSettings copy() {
    return SaladContractSettings(
      isActive: isActive,
      contracts: contracts,
      invertScore: invertScore,
    );
  }

  @override
  List<Object?> get props => [...super.props, contracts, invertScore];
}

/// A domino contract settings
class DominoContractSettings extends AbstractContractSettings {
  /// The points for each player rank, depending on the number of player in the game
  late Map<int, List<int>> points;

  DominoContractSettings({
    super.isActive,
    int? pointsFirstPlayer,
    int? pointsLastPlayer,
    Map<int, List<int>>? points,
  })  : assert((pointsLastPlayer != null && pointsFirstPlayer != null) ||
            points != null),
        super(contract: ContractsInfo.domino) {
    this.points =
        points ?? generatePointsLists(pointsFirstPlayer!, pointsLastPlayer!);
  }

  DominoContractSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : points = Map.castFrom({
          for (var entry in jsonDecode(json["points"]).entries)
            int.parse(entry.key): List<int>.from(entry.value),
        }),
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "points": jsonEncode(
        {
          for (var entry in points.entries) '${entry.key}': entry.value,
        },
      )
    };
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
  DominoContractSettings copy() {
    return DominoContractSettings(isActive: isActive, points: points);
  }

  @override
  List<Object?> get props => [...super.props, points];
}
