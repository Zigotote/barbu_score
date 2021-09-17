import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract.dart';

/// A player for a party
class PlayerController extends GetxController {
  /// The color of the player
  Rx<Color> _color;

  /// The image of the player
  RxString _image;

  /// The observable name of the player
  RxString _name;

  /// The contracts the player has finished
  List<ContractController> contracts;

  PlayerController(Color color, String image) {
    this._name = "".obs;
    this._color = color.obs;
    this._image = image.obs;
    this.contracts = [];
  }

  String get name => _name.value;

  set name(value) => _name.value = value.trim();

  Color get color => _color.value;

  set color(value) => _color.value = value;

  String get image => _image.value;

  set image(value) => _image.value = value;

  /// Returns the list of the contracts the player can choose
  List<ContractsNames> get availableContracts => ContractsNames.values
      .where((contractName) => !choosenContracts.contains(contractName))
      .toList();

  /// Returns the list of the contracts the player has already selected
  List<ContractsNames> get choosenContracts =>
      contracts.map((contract) => contract.name).toList();

  /// Adds a contract for the player, with the scores of each players
  void addContract(ContractsNames contract, Map<PlayerController, int> scores) {
    contracts.add(ContractController(contract, scores));
  }

  @override
  String toString() => _name.value;
}
