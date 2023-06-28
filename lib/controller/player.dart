import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../pages/play_game/models/contract_info.dart';
import '../pages/play_game/models/contract_models.dart';

/// A player for a party
class PlayerController extends GetxController {
  /// The color of the player
  late Rx<Color> _color;

  /// The image of the player
  late RxString _image;

  /// The observable name of the player
  late RxString _name;

  /// The contracts the player has finished
  late List<AbstractContractModel> _contracts;

  PlayerController(Color color, String image) {
    this._name = "".obs;
    this._color = color.obs;
    this._image = image.obs;
    this._contracts = [];
  }

  PlayerController.fromJson(Map<String, dynamic> json)
      : _name = _dynamicToString(json["name"]).obs,
        _color = Color(json["color"]).obs,
        _image = _dynamicToString(json["image"]).obs,
        _contracts = ((json["contracts"] as List)
            .map((contractData) => AbstractContractModel.fromJson(contractData))
            .toList());

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "color": color.value,
      "image": image,
      "contracts": _contracts.map((contract) => contract.toJson()).toList()
    };
  }

  String get name => _name.value;

  set name(value) => _name.value = value.trim();

  Color get color => _color.value;

  set color(value) => _color.value = value;

  String get image => _image.value;

  set image(value) => _image.value = value;

  /// Returns the list of the contracts the player can choose
  List<ContractsInfo> get availableContracts => ContractsInfo.values
      .where((contract) => !_choosenContracts.contains(contract.name))
      .toList();

  /// Returns the list of the contracts the player has already selected
  List<String> get _choosenContracts =>
      _contracts.map((contract) => contract.name).toList();

  /// Returns the scores of each player, for the contracts of this player
  Map<String, int> get playerScores {
    if (_contracts.isEmpty) {
      return Map.fromIterable(
        Get.find<PartyController>().players,
        key: (player) => player.name,
        value: (_) => 0,
      );
    }
    return AbstractContractModel.calculateTotalScore(_contracts);
  }

  /// Adds a contract played by a player, created from its name.
  /// The score is calculated from the Map wich links the number of card or trick each player won.
  /// Returns true if the score has been added, false otherwise
  bool addContract(ContractsInfo contractName, Map<String, int> trickByPlayer) {
    AbstractContractModel contract = contractName.contract;
    final bool isValidScore = contract.calculateScores(trickByPlayer);
    if (isValidScore) {
      _contracts.removeWhere((c) => c.name == contractName.name);
      _contracts.add(contract);
    }
    return isValidScore;
  }

  /// Returns the filled contract model for this contract name. Returns null if there is no contract
  AbstractContractModel? getContract(String contractName) {
    return _contracts.firstWhereOrNull(
      (contract) => contract.name == contractName,
    );
  }

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsInfo contract) {
    return _choosenContracts.contains(contract.name);
  }

  /// Returns the scores for the contract. If it has not been played, all player have a score of 0
  Map<String, int> contractScores(String contractName) {
    AbstractContractModel? contract = this.getContract(contractName);
    if (contract == null) {
      return Map.fromIterable(
        Get.find<PartyController>().players,
        key: (player) => player.name,
        value: (_) => 0,
      );
    }
    return contract.scores;
  }

  @override
  String toString() => _name.value;

  static String _dynamicToString(dynamic str) {
    return str as String;
  }
}
