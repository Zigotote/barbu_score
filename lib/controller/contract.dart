import 'dart:collection';

import 'package:get/get.dart';

import '../controller/player.dart';

/// An abstract controller for the contracts
abstract class ContractController extends GetxController {
  /// Returns true if the score is valid, false otherwise
  bool get isValid;
}

/// A controller to manage box position to show which item is selected
class SelectPlayerController extends ContractController {
  /// The top position of the selection box
  RxDouble _topPositionSelectionBox;

  /// The left position of the selection box
  RxDouble _leftPositionSelectionBox;

  /// The index of the selected player
  RxInt _selectedPlayerIndex;

  SelectPlayerController() {
    this._selectedPlayerIndex = (-1).obs;
    this._topPositionSelectionBox = (0.0).obs;
    this._leftPositionSelectionBox = (0.0).obs;
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
      _leftPositionSelectionBox.value = 0.0;
    } else {
      _leftPositionSelectionBox.value = Get.width * 0.48;
    }
    _topPositionSelectionBox.value =
        Get.height * 0.021 + (Get.height * 0.178) * (index ~/ 2);
  }
}

/// A controller to manage box position to show which item is selected
class OrderPlayersController extends ContractController {
  /// The ordered list of players
  RxList<PlayerController> orderedPlayers;

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
}

/// A controller to manage the score of each player, for a particular contract
class IndividualScoresController extends ContractController {
  /// The map which links each player to his score
  RxMap<PlayerController, int> _playerScores;

  /// The maximal score for the current contract
  int maximalScore;

  IndividualScoresController(List players) {
    this._playerScores = Map<PlayerController, int>.fromIterable(
      players,
      key: (player) => player,
      value: (_) => 0,
    ).obs;
  }

  @override
  bool get isValid {
    final int currentScore = _playerScores.values
        .fold(0, (previousValue, element) => previousValue + element);
    return currentScore == maximalScore;
  }

  UnmodifiableMapView<PlayerController, int> get playerScores =>
      UnmodifiableMapView(_playerScores);

  /// Increases the score of the player, only if the total score is less than the contract max score
  void increaseScore(PlayerController player) {
    if (this.isValid) {
      Get.snackbar(
        "Ajout de points impossible",
        "Le nombre d'items dépasse le nombre d'éléments pouvant être remporté, fixé à $maximalScore.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      _playerScores[player]++;
    }
  }

  /// Decreases the score of the player. It cant't go behind 0
  void decreaseScore(PlayerController player) {
    if (_playerScores[player] >= 1) {
      _playerScores[player]--;
    }
  }
}
