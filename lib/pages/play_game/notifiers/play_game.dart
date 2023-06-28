import 'dart:collection';

import 'package:barbu_score/pages/create_game/notifiers/create_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../models/player.dart';
import '../models/contract_info.dart';
import '../models/contract_models.dart';

final playGameProvider = ChangeNotifierProvider.autoDispose<PlayGameNotifier>(
  (ref) => PlayGameNotifier(ref.read(createGameProvider).players),
);

class PlayGameNotifier with ChangeNotifier {
  /// The list of players for the game
  List<Player> _players;

  /// The index of the current player
  int _currentPlayerIndex;

  PlayGameNotifier(this._players) : _currentPlayerIndex = 0;

  /// Returns the player list
  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  /// Returns the current player
  Player get currentPlayer => _players[_currentPlayerIndex];

  /// Saves the score for the contract and changes the current player to the next one
  /// Returns true if the score is valid
  bool finishContract(
      ContractsInfo contractInfo, Map<String, int> itemsByPlayer) {
    final bool isValidScore =
        this.currentPlayer.addContract(contractInfo, itemsByPlayer);
    return isValidScore;
  }

  /// Changes the current player to the next one
  /// Returns true if their is a next player, false if the game is finished
  bool nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == this._players.length) {
      _currentPlayerIndex = 0;
    }
    if (this.currentPlayer.availableContracts.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
