import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/player.dart';
import '../models/game.dart';
import '../utils/storage.dart';

final playGameProvider =
    ChangeNotifierProvider<PlayGameNotifier>((ref) => PlayGameNotifier());

class PlayGameNotifier with ChangeNotifier {
  /// The object representing the game
  late Game _game;

  PlayGameNotifier();

  /// Returns the player list
  List<Player> get players => _game.players;

  /// Returns the current player
  Player get currentPlayer => _game.currentPlayer;

  /// Inits the game with the players
  init(List<Player> players) {
    _game = Game(players: players);
  }

  /// Loads a previous game
  load(Game game) {
    _game = game;
  }

  /// Saves the score for the contract and changes the current player to the next one
  /// Returns true if the score is valid
  bool finishContract(
      ContractsInfo contractInfo, Map<String, int> itemsByPlayer) {
    return _game.currentPlayer.addContract(contractInfo, itemsByPlayer);
  }

  /// Changes the current player to the next one
  /// Returns true if there is a next player, false if the game is finished
  bool nextPlayer() {
    _game.nextPlayer();
    notifyListeners();
    MyStorage().saveGame(_game);
    return !_game.isFinished;
  }
}
