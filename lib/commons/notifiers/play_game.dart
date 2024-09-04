import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/player.dart';
import '../models/contract_models.dart';
import '../models/game.dart';
import 'storage.dart';

final playGameProvider = ChangeNotifierProvider<PlayGameNotifier>(
  (ref) => PlayGameNotifier(ref.read(storageProvider)),
);

class PlayGameNotifier with ChangeNotifier {
  /// The object representing the game
  late Game game;

  /// The storage manager
  final MyStorage storage;

  PlayGameNotifier(this.storage);

  /// Returns the player list
  List<Player> get players => game.players;

  /// Returns the current player
  Player get currentPlayer => game.currentPlayer;

  /// Inits the game with the players
  init(List<Player> players) {
    game = Game(players: players);
  }

  /// Loads a previous game
  load(Game game) {
    this.game = game;
  }

  /// Saves the score for the contract
  void finishContract(AbstractContractModel contract) {
    game.currentPlayer.addContract(contract);
  }

  /// Changes the current player to the next one
  /// Returns true if there is a next player, false if the game is finished
  bool nextPlayer() {
    final previousPlayer = game.currentPlayer;
    final activeContracts = storage.getActiveContracts();
    game.nextPlayer();
    bool playerHasAvailableContracts =
        game.currentPlayer.hasAvailableContracts(activeContracts);
    while (
        !playerHasAvailableContracts && game.currentPlayer != previousPlayer) {
      game.nextPlayer();
      playerHasAvailableContracts =
          game.currentPlayer.hasAvailableContracts(activeContracts);
    }
    game.isFinished = !playerHasAvailableContracts;
    notifyListeners();
    storage.saveGame(game);
    return !game.isFinished;
  }
}
