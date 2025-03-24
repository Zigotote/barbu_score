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
        AbstractSubContractModel.fromJson(contract, json),
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
abstract class AbstractSubContractModel extends AbstractContractModel {
  /// The number of items each player won for this contract
  Map<String, int> _itemsByPlayer;

  AbstractSubContractModel(
      {super.contract, super.name, Map<String, int> itemsByPlayer = const {}})
      : _itemsByPlayer = itemsByPlayer;

  factory AbstractSubContractModel.fromJson(
      ContractsInfo contract, Map<String, dynamic> json) {
    return switch (contract) {
      ContractsInfo.barbu ||
      ContractsInfo.noLastTrick =>
        OneLooserContractModel.fromJson(contract, json),
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks =>
        MultipleLooserContractModel.fromJson(contract, json),
      _ => throw UnimplementedError(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "itemsByPlayer": jsonEncode(_itemsByPlayer)};
  }

  @override
  List<Object?> get props => [...super.props, _itemsByPlayer];

  /// The number of item of the players. Used to modify the contract.
  UnmodifiableMapView<String, int> get itemsByPlayer =>
      UnmodifiableMapView(_itemsByPlayer);

  /// Returns true if the [itemsByPlayer] are valid, depending on the type of contract
  bool isValid(Map<String, int> itemsByPlayer);

  /// Returns the maximal number of points of the contract
  int maxPoints(AbstractContractSettings settings);

  /// Sets the [itemsByPlayer] from a Map which links all player's names with the number of tricks/cards they won.
  /// Returns true if the map is valid, false otherwise
  bool setItemsByPlayer(Map<String, int> itemsByPlayer) {
    final canBeSet = isValid(itemsByPlayer);
    if (canBeSet) {
      _itemsByPlayer = itemsByPlayer;
    }
    return canBeSet;
  }

  @override
  String toString() {
    return "${super.toString()} : $_itemsByPlayer";
  }
}

/// A class to fill the scores for a contract which has only one looser
class OneLooserContractModel extends AbstractSubContractModel {
  OneLooserContractModel({super.contract, super.name, super.itemsByPlayer});

  OneLooserContractModel.fromJson(
      ContractsInfo contract, Map<String, dynamic> json)
      : super(
          contract: contract,
          itemsByPlayer: Map.castFrom(jsonDecode(json["itemsByPlayer"])),
        );

  @override
  bool isValid(Map<String, int> itemsByPlayer) {
    return itemsByPlayer.entries.where((entry) => entry.value == 1).length ==
            1 &&
        itemsByPlayer.entries
            .none((entry) => entry.value > 1 || entry.value < 0);
  }

  @override
  int maxPoints(AbstractContractSettings settings) {
    return (settings as OneLooserContractSettings).points;
  }

  @override
  Map<String, int>? scores(AbstractContractSettings settings) {
    if (_itemsByPlayer.isEmpty) {
      return null;
    }
    return _itemsByPlayer.map(
      (playerName, nbItems) => MapEntry(
          playerName, nbItems * (settings as OneLooserContractSettings).points),
    );
  }
}

/// A class to fill the scores for a contract where multiple players can have some points
class MultipleLooserContractModel extends AbstractSubContractModel {
  /// The number of item (card or trick) the deck should have
  final int nbItems;

  MultipleLooserContractModel(
      {super.contract, super.name, super.itemsByPlayer, required this.nbItems});

  MultipleLooserContractModel.fromJson(
      ContractsInfo contract, Map<String, dynamic> json)
      : nbItems = json["nbItems"],
        super(
          contract: contract,
          itemsByPlayer: Map.castFrom(jsonDecode(json["itemsByPlayer"])),
        );

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "nbItems": nbItems};
  }

  @override
  List<Object?> get props => [...super.props, nbItems];

  @override
  bool isValid(Map<String, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    return declaredItems == nbItems;
  }

  @override
  int maxPoints(AbstractContractSettings settings) {
    return (settings as MultipleLooserContractSettings).points * nbItems;
  }

  @override
  Map<String, int>? scores(AbstractContractSettings settings) {
    if (_itemsByPlayer.isEmpty) {
      return null;
    }
    final individualScoresSettings = settings as MultipleLooserContractSettings;
    final Map<String, int> scores = {};

    final playerWithAllItems = itemsByPlayer.entries
        .firstWhereOrNull((playerItems) => playerItems.value == nbItems)
        ?.key;
    if (playerWithAllItems != null) {
      int score = maxPoints(settings);
      if (individualScoresSettings.invertScore) {
        score = -score;
      }
      scores[playerWithAllItems] = score;
      itemsByPlayer.forEach(
        (player, items) => scores.putIfAbsent(player, () => 0),
      );
    } else {
      itemsByPlayer.forEach((player, value) {
        scores[player] = value * individualScoresSettings.points;
      });
    }
    return scores;
  }
}

/// A salad contract scores
class SaladContractModel extends AbstractContractModel {
  final List<AbstractSubContractModel> subContracts;

  SaladContractModel({List<AbstractSubContractModel>? subContracts})
      : subContracts = subContracts ?? [],
        super(contract: ContractsInfo.salad);

  SaladContractModel.fromJson(ContractsInfo contract, Map<String, dynamic> json)
      : subContracts = ((jsonDecode(json["subContracts"]) as List)
            .map(
              (subContractJson) => AbstractSubContractModel.fromJson(
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

  void addSubContract(AbstractSubContractModel contract) {
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
                    ),
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
  Map<String, int> _rankOfPlayer;

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

  /// Sets the [rankOfPlayer] from a Map wich links all player's names with its rank.
  /// Returns true if the map is valid, false otherwise
  bool setRankOfPlayer(Map<String, int> rankOfPlayer) {
    if (rankOfPlayer.isEmpty) {
      return false;
    }
    _rankOfPlayer = rankOfPlayer;
    return true;
  }

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
