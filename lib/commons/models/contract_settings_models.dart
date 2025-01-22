import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sprintf/sprintf.dart';

import '../utils/constants.dart';
import 'contract_info.dart';

part 'contract_settings_models.g.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings with EquatableMixin {
  /// The name of the contract
  @HiveField(3)
  final String name;

  /// The indicator to know if the user wants to have this contract in its games or not
  @HiveField(0)
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
      ContractsInfo.trumps => TrumpsContractSettings.fromJson(
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

  /// Fills the rules depending on the contract settings
  String filledRules(String rules);

  /// Copies the object with some overrides
  AbstractContractSettings copy();

  @override
  List<Object?> get props => [name, isActive];
}

/// A class to save the settings for a contract where only one player can loose
@HiveType(typeId: 9)
class OneLooserContractSettings extends AbstractContractSettings {
  /// The points for this contract item
  @HiveField(1)
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
  String filledRules(String rules) {
    return sprintf(rules, [points]);
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
@HiveType(typeId: 10)
class MultipleLooserContractSettings extends AbstractContractSettings {
  /// The points for one item
  @HiveField(1)
  int points;

  /// The indicator to know if the score should be inverted if one players wins all contract items
  @HiveField(2)
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
  String filledRules(String rules) {
    String invertScoreSentence = "";
    if (invertScore) {
      invertScoreSentence =
          " Si un joueur remporte tout, son score devient négatif.";
    }
    return sprintf(rules, [points]) + invertScoreSentence;
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
  @Deprecated("should use [contracts] instead")
  final Map<ContractsInfo, bool>? c;

  /// A map to know if each contract should be part of trumps contract or not
  final Map<String, bool> contracts;

  TrumpsContractSettings({super.isActive, this.c, Map<String, bool>? contracts})
      : assert(c != null || contracts != null),
        contracts = contracts ??
            {
              for (var contract in c!.entries) contract.key.name: contract.value
            },
        super(contract: ContractsInfo.trumps);

  TrumpsContractSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : contracts = Map.castFrom(jsonDecode(json["contracts"])),
        c = {},
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "contracts": jsonEncode(contracts)};
  }

  /// Returns the active contracts
  List<ContractsInfo> get activeContracts => contracts.entries
      .where((contract) => contract.value)
      .map((contract) => ContractsInfo.fromName(contract.key))
      .toList();

  @override
  String filledRules(String rules) {
    return sprintf(rules, [
      contracts.entries
          .where((contract) => contract.value)
          .toList()
          .map((e) => ContractsInfo.fromName(e.key)
              .displayName
              .toLowerCase()
              .replaceAll("sans ", ""))
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
  List<Object?> get props => [...super.props, contracts];
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
  String filledRules(String rules) {
    return rules;
  }

  @override
  DominoContractSettings copy() {
    return DominoContractSettings(isActive: isActive, points: points);
  }

  @override
  List<Object?> get props => [...super.props, points];
}
