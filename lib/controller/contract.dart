import 'dart:collection';

import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_models.dart';
import '../models/contract_names.dart';
import '../utils/snackbar.dart';

/// An abstract controller for the contracts
abstract class AbstractContractController extends GetxController {
  /// Returns true if the score is valid, false otherwise
  bool get isValid;

  /// Returns the map to calculate the scores for the contract
  Map<String, int> get playerScores;
}

/// A controller to manage box position to show which item is selected
class SelectPlayerController extends AbstractContractController {
  /// The top position of the selection box
  late RxDouble _topPositionSelectionBox;

  /// The left position of the selection box
  late RxDouble _leftPositionSelectionBox;

  /// The index of the selected player
  late RxInt _selectedPlayerIndex;

  SelectPlayerController({int defaultIndex = -1}) {
    this._selectedPlayerIndex = defaultIndex.obs;
    this._topPositionSelectionBox = (0.0).obs;
    this._leftPositionSelectionBox = (0.0).obs;
    if (defaultIndex >= 0) {
      this.selectedPlayerIndex = defaultIndex;
    }
  }

  @override
  bool get isValid => _selectedPlayerIndex.value != -1;

  double get topPositionSelectionBox => _topPositionSelectionBox.value;

  double get leftPositionSelectionBox => _leftPositionSelectionBox.value;

  int get selectedPlayerIndex => _selectedPlayerIndex.value;

  /// Sets the selected player index and adapts the box position depending on it
  set selectedPlayerIndex(int index) {
    _selectedPlayerIndex.value = index;
    if (index % 2 == 0) {
      _leftPositionSelectionBox.value = 2.0;
    } else {
      _leftPositionSelectionBox.value = Get.width * 0.43 + 24;
    }
    _topPositionSelectionBox.value =
        6 + ((Get.height * 0.15 + 20) * (index ~/ 2));
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
      SnackbarUtils.openSnackbar(
        "Ajout de points impossible",
        "Le nombre d'items dépasse le nombre d'éléments pouvant être remporté, fixé à $maximalScore.",
      );
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
  final List<ContractsNames> trumpContracts = ContractsNames.values
      .where((contractName) =>
          contractName != ContractsNames.Trumps &&
          contractName != ContractsNames.Domino)
      .toList();

  /// The contracts the player has filled
  late RxList<AbstractContractModel> _filledContracts;

  TrumpsScoresController() {
    this._filledContracts = <AbstractContractModel>[].obs;
  }

  @override
  bool get isValid => _filledContracts.length == this.trumpContracts.length;

  /// Returns the filled contract which matches the contractName. If there is none, returns null
  AbstractContractModel? getFilledContract(ContractsNames contractName) {
    return _filledContracts
        .firstWhereOrNull((contract) => contract.name == contractName);
  }

  /// Returns true if the contract has been filled
  bool isFilled(ContractsNames contractName) {
    return this.getFilledContract(contractName) != null;
  }

  /// Adds a contract to the filledContracts list
  addContract(ContractsNames contractName, Map<String, int> playerScores) {
    _filledContracts.removeWhere((contract) => contract.name == contractName);
    AbstractContractModel contract = contractName.contract;
    contract.setScores(playerScores);
    _filledContracts.add(contract);
  }

  @override
  Map<String, int> get playerScores {
    return AbstractContractModel.calculateTotalScore(_filledContracts);
  }
}
