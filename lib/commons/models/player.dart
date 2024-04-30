import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/globals.dart';
import 'contract_info.dart';
import 'contract_models.dart';
import 'contract_settings_models.dart';
import 'player_colors.dart';

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

  /// Returns true if the player can choose at least one contract from the list, false if he already choose all of them
  bool hasAvailableContracts(List<ContractsInfo> activeContracts) {
    return activeContracts.length != _chosenContracts.length;
  }

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsInfo contract) {
    return _chosenContracts.contains(contract.name);
  }

  /// Adds a contract played by a player
  void addContract(AbstractContractModel contract) {
    contracts.removeWhere((c) => c.name == contract.name);
    contracts.add(contract);
  }

  /// Returns the scores for the contract. Returns null if it has not been played
  Map<String, int>? contractScores(
      ContractsInfo contract, AbstractContractSettings settings) {
    final AbstractContractModel? contractModel =
        contracts.firstWhereOrNull((c) => c.name == contract.name);
    return contractModel?.scores(settings);
  }

  @override
  String toString() {
    return "$name : $contracts";
  }
}
