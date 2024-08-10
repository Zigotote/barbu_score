import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'contract_info.dart';
import 'contract_settings_models.dart';

part 'contract_models.g.dart';

/// An abstract class to fill the items won by players for a contract
abstract class AbstractContractModel with EquatableMixin {
  /// The name of the contract
  @HiveField(0)
  final String name;

  AbstractContractModel({ContractsInfo? contract, String? name})
      : assert(name == null || contract == null,
            "Only name or contract should be used"),
        name = name ?? contract!.name;

  /// Calculates the scores of this contract from its settings. Returns null score if it can't be calculated
  Map<String, int>? scores(AbstractContractSettings settings);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name];
}

/// A class to represent a contracts that can be part of a trumps contract
abstract class AbstractSubContractModel extends AbstractContractModel {
  /// The number of items each player won for this contract
  @HiveField(1)
  Map<String, int> _itemsByPlayer;

  AbstractSubContractModel({super.contract, super.name}) : _itemsByPlayer = {};

  @override
  List<Object?> get props => [...super.props, _itemsByPlayer];

  /// The number of item of the players. Used to modify the contract.
  UnmodifiableMapView<String, int> get itemsByPlayer =>
      UnmodifiableMapView(_itemsByPlayer);

  /// Returns true if the [itemsByPlayer] are valid, depending on the type of contract
  bool isValid(Map<String, int> itemsByPlayer);

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
@HiveType(typeId: 15)
class OneLooserContractModel extends AbstractSubContractModel {
  OneLooserContractModel({super.contract, super.name});

  @override
  bool isValid(Map<String, int> itemsByPlayer) {
    return itemsByPlayer.entries.where((entry) => entry.value == 1).length ==
            1 &&
        itemsByPlayer.entries
            .none((entry) => entry.value > 1 || entry.value < 0);
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
@HiveType(typeId: 16)
class MultipleLooserContractModel extends AbstractSubContractModel {
  /// The number of item (card or trick) the deck should have
  @HiveField(2)
  final int nbItems;

  MultipleLooserContractModel(
      {super.contract, super.name, required this.nbItems});

  @override
  List<Object?> get props => [...super.props, nbItems];

  @override
  bool isValid(Map<String, int> itemsByPlayer) {
    final int declaredItems = itemsByPlayer.values
        .fold(0, (previousValue, element) => previousValue + element);
    return declaredItems == nbItems;
  }

  @override
  Map<String, int>? scores(AbstractContractSettings settings) {
    if (_itemsByPlayer.isEmpty) {
      return null;
    }
    final individualScoresSettings = settings as MultipleLooserContractSettings;
    final Map<String, int> scores = {};

    MapEntry<String, int> playerWithAllItems = itemsByPlayer.entries.firstWhere(
        (playerItems) => playerItems.value == nbItems,
        orElse: () => const MapEntry("", 0));
    if (playerWithAllItems.key.isNotEmpty) {
      int score = playerWithAllItems.value * individualScoresSettings.points;
      if (individualScoresSettings.invertScore) {
        score = -score;
      }
      scores[playerWithAllItems.key] = score;
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

/// A trumps contract scores
@HiveType(typeId: 7)
class TrumpsContractModel extends AbstractContractModel {
  @HiveField(1)
  final List<AbstractSubContractModel> _subContracts = [];

  TrumpsContractModel() : super(contract: ContractsInfo.trumps);

  @override
  List<Object?> get props => [...super.props, _subContracts];

  UnmodifiableListView<AbstractSubContractModel> get subContracts =>
      UnmodifiableListView(_subContracts);

  void addSubContract(AbstractSubContractModel contract) {
    _subContracts
        .removeWhere((subContract) => contract.name == subContract.name);
    _subContracts.add(contract);
  }

  /// Calculates the scores of this contract from a list of settings. Returns null if scores can't be calculated
  @override
  Map<String, int>? scores(AbstractContractSettings settings,
      [List<AbstractContractSettings>? subContractSettings]) {
    if (subContractSettings == null || _subContracts.isEmpty) {
      return null;
    }
    // Checks if all contracts are active
    if (_subContracts.map((subContract) => subContract.name).toList().equals(
        (settings as TrumpsContractSettings)
            .activeContracts
            .map((contract) => contract.name)
            .toList())) {
      return null;
    }
    // Checks if all sub contract has settings
    if (_subContracts.any((contract) => subContractSettings
        .none((settings) => settings.name == contract.name))) {
      return null;
    }
    return _subContracts
        .map(
          (subContract) => subContract.scores(
            subContractSettings
                .firstWhere((setting) => setting.name == subContract.name),
          ),
        )
        .reduce(
          (scores, subContractScores) => scores
            ?..updateAll(
              (player, playerScores) =>
                  playerScores + subContractScores![player]!,
            ),
        );
  }
}

/// A domino contract scores
@HiveType(typeId: 8)
class DominoContractModel extends AbstractContractModel {
  /// The rank where each player finished this contract
  @HiveField(1)
  Map<String, int> _rankOfPlayer = {};

  DominoContractModel() : super(contract: ContractsInfo.domino);

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
