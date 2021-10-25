import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/contract_models.dart';
import '../models/contract_names.dart';

/// A player for a party
class PlayerController extends GetxController {
  /// The color of the player
  Rx<Color> _color;

  /// The image of the player
  RxString _image;

  /// The observable name of the player
  RxString _name;

  /// The contracts the player has finished
  List<AbstractContractModel> _contracts;

  PlayerController(Color color, String image) {
    this._name = "test $image".obs;
    this._color = color.obs;
    this._image = image.obs;
    this._contracts = [];
  }

  String get name => _name.value;

  set name(value) => _name.value = value.trim();

  Color get color => _color.value;

  set color(value) => _color.value = value;

  String get image => _image.value;

  set image(value) => _image.value = value;

  /// Returns the list of the contracts the player can choose
  List<ContractsNames> get availableContracts => ContractsNames.values
      .where((contractName) => !_choosenContracts.contains(contractName))
      .toList();

  /// Returns the list of the contracts the player has already selected
  List<ContractsNames> get _choosenContracts =>
      _contracts.map((contract) => contract.name).toList();

  /// Adds a contract played by a player, created from its name.
  /// The score is calculated from the Map wich links the number of card or trick each player won.
  void addContract(
      ContractsNames contractName, Map<PlayerController, int> trickByPlayer) {
    AbstractContractModel contract = contractName.contract;
    contract.setScores(trickByPlayer);
    _contracts.add(contract);
  }

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsNames contractName) {
    return !availableContracts.contains(contractName);
  }

  @override
  String toString() => _name.value;
}
