import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils/globals.dart';
import 'contract_info.dart';
import 'contract_models.dart';
import 'player_colors.dart';

class Player with EquatableMixin {
  /// The image of the player
  String image;

  /// The name of the color key
  PlayerColors color;

  /// The name of the player
  String name;

  /// The contracts the player has finished
  final List<AbstractContractModel> contracts;

  Player({
    required this.image,
    required this.color,
    this.name = "",
    required this.contracts,
  });

  factory Player.create(
          {required PlayerColors color, required String image, String? name}) =>
      Player(
        name: name ?? (kDebugMode && !kIsTest ? image : ""),
        image: image,
        color: color,
        contracts: [],
      );

  Player.fromJson(dynamic json)
      : name = json["name"] as String,
        color = PlayerColors.fromName(json["color"]),
        image = json["image"] as String,
        contracts = ((jsonDecode(json["contracts"]) as List)
            .map((contractData) => AbstractContractModel.fromJson(contractData))
            .toList());

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "color": color.name,
      "image": image,
      "contracts": jsonEncode(
        contracts.map((contract) => contract.toJson()).toList(),
      )
    };
  }

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

  @override
  String toString() {
    return "$name : $contracts";
  }

  @override
  List<Object?> get props => [image, name, contracts, color];
}
