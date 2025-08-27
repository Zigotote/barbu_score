import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../utils/constants.dart';
import 'contract_info.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings {
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
      ContractsInfo.noLastTrick ||
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks =>
        ContractWithPointsSettings.fromJson(
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

  @override
  int get hashCode => Object.hash(this, name);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AbstractContractSettings &&
            name == other.name &&
            isActive == other.isActive;
  }

  @override
  String toString() {
    return "$name: isActive=$isActive";
  }

  AbstractContractSettings copyWith({bool? isActive});
}

/// A class to save the settings for a contract where multiple players can have some points
class ContractWithPointsSettings extends AbstractContractSettings {
  /// The points for one item
  int points;

  /// The indicator to know if the score should be inverted if one players wins all contract items
  bool invertScore;

  ContractWithPointsSettings({
    super.contract,
    super.name,
    super.isActive,
    required this.points,
    this.invertScore = false,
  });

  ContractWithPointsSettings.fromJson(Map<String, dynamic> json,
      {required ContractsInfo contract, required super.isActive})
      : points = json["points"],
        invertScore = json["invertScore"],
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "points": points, "invertScore": invertScore};
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return super == other &&
        points == (other as ContractWithPointsSettings).points &&
        invertScore == other.invertScore;
  }

  @override
  String toString() {
    return "${super.toString()}, points=$points, invertScore=$invertScore";
  }

  @override
  ContractWithPointsSettings copyWith(
      {bool? isActive, int? points, bool? invertScore}) {
    return ContractWithPointsSettings(
      name: name,
      isActive: isActive ?? this.isActive,
      points: points ?? this.points,
      invertScore: invertScore ?? this.invertScore,
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
  Map<String, bool> contracts;

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

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return super == other &&
        (other as SaladContractSettings)
            .contracts
            .entries
            .every((entry) => entry.value == contracts[entry.key]) &&
        invertScore == other.invertScore;
  }

  @override
  String toString() {
    return "${super.toString()}, contracts=$contracts, invertScore=$invertScore";
  }

  /// Returns the active contracts
  UnmodifiableListView<ContractsInfo> get activeContracts =>
      UnmodifiableListView(contracts.entries
          .where((contract) => contract.value)
          .map((contract) => ContractsInfo.fromName(contract.key)));

  @override
  SaladContractSettings copyWith(
      {bool? isActive, Map<String, bool>? contracts, bool? invertScore}) {
    return SaladContractSettings(
      isActive: isActive ?? this.isActive,
      contracts: contracts ?? Map.from(this.contracts),
      invertScore: invertScore ?? this.invertScore,
    );
  }
}

/// A domino contract settings
class DominoContractSettings extends AbstractContractSettings {
  /// The points for each player rank, depending on the number of player in the game
  Map<int, List<int>> points = {};

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

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return super == other &&
        points.entries.every(
          (entry) => entry.value.equals(
            (other as DominoContractSettings).points[entry.key] ?? [],
          ),
        );
  }

  @override
  String toString() {
    return "${super.toString()}, points=$points";
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
  DominoContractSettings copyWith(
      {bool? isActive, Map<int, List<int>>? points}) {
    return DominoContractSettings(
        isActive: isActive ?? this.isActive, points: points ?? this.points);
  }
}
