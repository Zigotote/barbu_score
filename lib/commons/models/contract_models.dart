import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'contract_info.dart';
import 'contract_settings_models.dart';

/// An abstract class to fill the items won by players for a contract
abstract class AbstractContractModel with EquatableMixin {
  /// The name of the contract
  final String name;

  AbstractContractModel({ContractsInfo? contract, String? name})
      : assert(name == null || contract == null,
            "Only name or contract should be used"),
        name = name ?? contract!.name;

  factory AbstractContractModel.fromJson(Map<String, dynamic> json) {
    final contract = ContractsInfo.fromName(json["name"]);
    return switch (contract) {
      ContractsInfo.barbu ||
      ContractsInfo.noLastTrick ||
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks =>
        ContractWithPointsModel.fromJson(contract, json),
      ContractsInfo.salad => SaladContractModel.fromJson(contract, json),
      ContractsInfo.domino => DominoContractModel.fromJson(contract, json)
    };
  }

  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  /// Calculates the scores of this contract from its settings. Returns null score if it can't be calculated
  Map<String, int>? scores(AbstractContractSettings settings);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name];
}

/// A class to represent a contract that can be part of a salad contract
class ContractWithPointsModel extends AbstractContractModel {
  /// The number of items each player won for this contract
  final Map<String, int> itemsByPlayer;

  /// The number of item (card or trick) the deck should have
  final int nbItems;

  ContractWithPointsModel(
      {super.contract,
      super.name,
      this.itemsByPlayer = const {},
      this.nbItems = 1});

  ContractWithPointsModel.fromJson(
      ContractsInfo contract, Map<String, dynamic> json)
      : itemsByPlayer = Map.castFrom(jsonDecode(json["itemsByPlayer"])),
        nbItems = json["nbItems"] ?? 1,
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "itemsByPlayer": jsonEncode(itemsByPlayer),
      "nbItems": nbItems,
    };
  }

  @override
  List<Object?> get props => [...super.props, itemsByPlayer, nbItems];

  ContractWithPointsModel copyWith({required Map<String, int> itemsByPlayer}) {
    return ContractWithPointsModel(
      name: name,
      nbItems: nbItems,
      itemsByPlayer: itemsByPlayer,
    );
  }

  bool isValid(Map<String, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    return declaredItems == nbItems;
  }

  int maxPoints(ContractWithPointsSettings settings) {
    return settings.points * nbItems;
  }

  @override
  Map<String, int>? scores(AbstractContractSettings settings) {
    if (itemsByPlayer.isEmpty) {
      return null;
    }

    final contractSettings = settings as ContractWithPointsSettings;
    final Map<String, int> scores = {};

    final playerWithAllItems = itemsByPlayer.entries
        .firstWhereOrNull((playerItems) => playerItems.value == nbItems)
        ?.key;
    if (playerWithAllItems != null) {
      int score = maxPoints(settings);
      if (contractSettings.invertScore) {
        score = -score;
      }
      scores[playerWithAllItems] = score;
      itemsByPlayer.forEach(
        (player, items) => scores.putIfAbsent(player, () => 0),
      );
    } else {
      itemsByPlayer.forEach((player, value) {
        scores[player] = value * contractSettings.points;
      });
    }
    return scores;
  }
}

/// A salad contract scores
class SaladContractModel extends AbstractContractModel {
  final List<ContractWithPointsModel> subContracts;

  SaladContractModel({List<ContractWithPointsModel>? subContracts})
      : subContracts = subContracts ?? [],
        super(contract: ContractsInfo.salad);

  SaladContractModel.fromJson(ContractsInfo contract, Map<String, dynamic> json)
      : subContracts = ((jsonDecode(json["subContracts"]) as List)
            .map(
              (subContractJson) => ContractWithPointsModel.fromJson(
                ContractsInfo.fromName(subContractJson["name"]),
                subContractJson,
              ),
            )
            .toList()),
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "subContracts": jsonEncode(
        subContracts.map((subContract) => subContract.toJson()).toList(),
      )
    };
  }

  @override
  List<Object?> get props => [...super.props, subContracts];

  void addSubContract(ContractWithPointsModel contract) {
    subContracts
        .removeWhere((subContract) => contract.name == subContract.name);
    subContracts.add(contract);
  }

  /// Calculates the scores of this contract from a list of settings. Returns null if scores can't be calculated
  @override
  Map<String, int>? scores(AbstractContractSettings settings,
      [List<AbstractContractSettings>? subContractSettings]) {
    if (subContractSettings == null || subContracts.isEmpty) {
      return null;
    }
    // Checks if all sub contract has settings
    if (subContracts.any((contract) => subContractSettings
        .none((settings) => settings.name == contract.name))) {
      return null;
    }

    final activeSubContracts = subContracts.where((subContract) =>
        (settings as SaladContractSettings).contracts[subContract.name] ==
        true);
    if ((settings as SaladContractSettings).invertScore) {
      final playerWithAllItems = activeSubContracts
          .expand((subContract) => subContract.itemsByPlayer.entries
              .where((playerScore) => playerScore.value != 0)
              .map((playerScore) => playerScore.key))
          .toSet();
      if (playerWithAllItems.length == 1) {
        final Map<String, int> scores = {};
        scores[playerWithAllItems.first] = -1 *
            activeSubContracts.fold(
              0,
              (sum, subContract) =>
                  sum +
                  subContract.maxPoints(
                    subContractSettings.firstWhere(
                      (setting) => setting.name == subContract.name,
                    ) as ContractWithPointsSettings,
                  ),
            );
        subContracts.first.itemsByPlayer.forEach(
          (player, items) => scores.putIfAbsent(player, () => 0),
        );
        return scores;
      }
    }
    return activeSubContracts
        .map(
          (subContract) => subContract.scores(
            subContractSettings.firstWhere(
              (setting) => setting.name == subContract.name,
            ),
          ),
        )
        .reduce(
          (scores, subContractScores) => scores == null
              ? subContractScores
              : (scores
                ..updateAll(
                  (player, playerScores) =>
                      playerScores + (subContractScores?[player] ?? 0),
                )),
        );
  }

  @override
  String toString() {
    return "${super.toString()} : ${subContracts.join(",")}";
  }
}

/// A domino contract scores
class DominoContractModel extends AbstractContractModel {
  /// The rank where each player finished this contract
  final Map<String, int> _rankOfPlayer;

  DominoContractModel({Map<String, int> rankOfPlayer = const {}})
      : _rankOfPlayer = rankOfPlayer,
        super(contract: ContractsInfo.domino);

  DominoContractModel.fromJson(
      ContractsInfo contract, Map<String, dynamic> json)
      : _rankOfPlayer = Map.castFrom(jsonDecode(json["rankOfPlayer"])),
        super(contract: contract);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "rankOfPlayer": jsonEncode(_rankOfPlayer)};
  }

  @override
  List<Object?> get props => [...super.props, _rankOfPlayer];

  /// Calculates the scores of this contract its settings. Returns null score can't be calculated
  @override
  Map<String, int>? scores(AbstractContractSettings settings) {
    if (_rankOfPlayer.isEmpty) {
      return null;
    }
    List<int> points =
        (settings as DominoContractSettings).points[_rankOfPlayer.length]!;
    return _rankOfPlayer.map((player, rank) => MapEntry(player, points[rank]));
  }

  @override
  String toString() {
    return "${super.toString()} : $_rankOfPlayer";
  }
}
