import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/globals.dart';
import '../utils/storage.dart';
import 'contract_info.dart';
import 'contract_models.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player {
  /// The color of the player
  @HiveField(0)
  @Deprecated("Use [color] instead")
  Color? c;

  /// The image of the player
  @HiveField(1)
  String image;

  /// The name of the player
  @HiveField(2)
  String name;

  /// The contracts the player has finished
  @HiveField(3)
  final List<AbstractContractModel> contracts;

  /// The name of the color key
  @HiveField(4)
  PlayerColors color;

  Player(
      {this.c,
      required this.image,
      this.name = "",
      required this.contracts,
      PlayerColors? color})
      : assert(c != null || color != null),
        color = color ?? PlayerColors.fromValue(c!);

  factory Player.create(
          {required PlayerColors color, required String image, String? name}) =>
      Player(
        name: name ?? (kDebugMode && !kIsTest ? image : ""),
        image: image,
        color: color,
        contracts: [],
      );

  /// Returns the list of the contracts the player has already selected
  List<String> get _chosenContracts =>
      contracts.map((contract) => contract.name).toList();

  /// Returns the list of the contracts the player can choose
  bool get hasAvailableContracts =>
      MyStorage.getActiveContracts().length != _chosenContracts.length;

  /// Returns the scores of each player, for the contracts of this player
  /// If the player has not played contracts it return null
  Map<String, int>? get playerScores {
    if (contracts.isEmpty) {
      return null;
    }
    return AbstractContractModel.calculateTotalScore(contracts);
  }

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsInfo contract) {
    return _chosenContracts.contains(contract.name);
  }

  /// Adds a contract played by a player, created from its name.
  /// The score is calculated from the Map wich links the number of card or trick each player won.
  /// Returns true if the score has been added, false otherwise
  bool addContract(ContractsInfo contractName, Map<String, int> trickByPlayer) {
    AbstractContractModel contract = contractName.contract;
    final bool isValidScore = contract.setScores(trickByPlayer);
    if (isValidScore) {
      contracts.removeWhere((c) => c.name == contractName.name);
      contracts.add(contract);
    }
    return isValidScore;
  }

  /// Returns the scores for the contract. Returns null if it has not been played
  Map<String, int>? contractScores(String contractName) {
    final AbstractContractModel? contract =
        contracts.firstWhereOrNull((contract) => contract.name == contractName);
    return contract?.scores;
  }

  @override
  String toString() {
    return "$name : $contracts";
  }
}
