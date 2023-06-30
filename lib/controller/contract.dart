import 'dart:collection';

import 'package:get/get.dart';

import '../commons/models/contract_info.dart';
import '../commons/models/contract_models.dart';
import '../controller/party.dart';
import '../controller/player.dart';

/// An abstract controller for the contracts
abstract class AbstractContractController extends GetxController {
  /// Returns true if the score is valid, false otherwise
  bool get isValid;

  /// Returns the map to calculate the scores for the contract
  Map<String, int> get playerScores;
}

/// A controller to manage box position to show which item is selected
class SelectPlayerController extends AbstractContractController {
  /// The index of the selected player
  late RxInt _selectedPlayerIndex;

  SelectPlayerController({int defaultIndex = -1}) {
    this._selectedPlayerIndex = defaultIndex.obs;
    if (defaultIndex >= 0) {
      this.selectedPlayerIndex = defaultIndex;
    }
  }

  @override
  bool get isValid => _selectedPlayerIndex.value != -1;

  int get selectedPlayerIndex => _selectedPlayerIndex.value;

  /// Sets the selected player index and adapts the box position depending on it
  set selectedPlayerIndex(int index) {
    _selectedPlayerIndex.value = index;
  }

  @override
  Map<String, int> get playerScores =>
      {Get.find<PartyController>().players[this.selectedPlayerIndex].name: 1};
}

/// A controller to manage box position to show which item is selected
class OrderPlayersController extends AbstractContractController {
  /// The ordered list of players
  late RxList<PlayerController> orderedPlayers;

  OrderPlayersController(List players) {
    this.orderedPlayers = List<PlayerController>.from(players).obs;
  }

  @override
  bool get isValid => orderedPlayers.length > 0;

  /// Moves a player from oldIndex to newIndex
  void movePlayer(int oldIndex, int newIndex) {
    PlayerController player = orderedPlayers.removeAt(oldIndex);
    orderedPlayers.insert(newIndex, player);
  }

  @override
  Map<String, int> get playerScores => Map.fromIterable(
        this.orderedPlayers,
        key: (player) => player.name,
        value: (player) => this.orderedPlayers.indexOf(player),
      );
}

/// A controller to manage the score of each player, for a particular contract
class IndividualScoresController extends AbstractContractController {
  /// The map which links each player name to his score
  late RxMap<String, int> _playerScores;

  /// The maximal score for the current contract
  late int maximalScore;

  IndividualScoresController(Map<String, int> players) {
    this._playerScores = players.obs;
  }

  @override
  bool get isValid {
    final int currentScore = _playerScores.values
        .fold(0, (previousValue, element) => previousValue + element);
    return currentScore == maximalScore;
  }

  @override
  UnmodifiableMapView<String, int> get playerScores =>
      UnmodifiableMapView(_playerScores);

  /// Increases the score of the player, only if the total score is less than the contract max score
  void increaseScore(PlayerController player) {
    if (this.isValid) {
      /*SnackbarUtils.openSnackBar(
        "Ajout de points impossible",
        "Le nombre d'items dépasse le nombre d'éléments pouvant être remporté, fixé à $maximalScore.",
      );*/
    } else {
      int? playerScore = _playerScores[player.name];
      if (playerScore != null) {
        _playerScores[player.name] = playerScore + 1;
      }
    }
  }

  /// Decreases the score of the player. It cant't go behind 0
  void decreaseScore(PlayerController player) {
    int? playerScore = _playerScores[player.name];
    if (playerScore != null && playerScore >= 1) {
      _playerScores[player.name] = playerScore - 1;
    }
  }
}

/// A controller for the trump contract
class TrumpsScoresController extends AbstractContractController {
  /// The list of contracts to fill for a trump contract
  final List<ContractsInfo> trumpContracts = ContractsInfo.values
      .where((contractInfo) =>
          contractInfo != ContractsInfo.Trumps &&
          contractInfo != ContractsInfo.Domino)
      .toList();

  /// The contracts the player has filled
  late RxList<AbstractContractModel> _filledContracts;

  TrumpsScoresController() {
    this._filledContracts = <AbstractContractModel>[].obs;
  }

  @override
  bool get isValid => _filledContracts.length == this.trumpContracts.length;

  /// Returns the filled contract which matches the contractName. If there is none, returns null
  AbstractContractModel? getFilledContract(String contractName) {
    return _filledContracts
        .firstWhereOrNull((contract) => contract.name == contractName);
  }

  /// Returns true if the contract has been filled
  bool isFilled(String contractName) {
    return this.getFilledContract(contractName) != null;
  }

  /// Adds a contract to the filledContracts list
  addContract(ContractsInfo contractInfo, Map<String, int> playerScores) {
    _filledContracts
        .removeWhere((contract) => contract.name == contractInfo.name);
    AbstractContractModel contract = contractInfo.contract;
    contract.setScores(playerScores);
    _filledContracts.add(contract);
  }

  @override
  Map<String, int> get playerScores {
    return AbstractContractModel.calculateTotalScore(_filledContracts);
  }
}
