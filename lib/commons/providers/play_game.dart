import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

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
  void init(List<Player> players) {
    game = Game(players: players);
  }

  /// Loads a previous game
  void load(Game game) {
    this.game = game;
  }

  /// Finds the first player who has available contracts, depending on the current settings
  /// Returns true if such a player exists, and moves game's current player to him
  /// false if the game is finished
  bool moveToFirstPlayerWithAvailableContracts() {
    final firstPlayer = game.currentPlayer;
    final activeContracts = storage.getActiveContracts();
    bool playerHasAvailableContracts = game.currentPlayer.hasAvailableContracts(
      activeContracts,
    );
    if (!playerHasAvailableContracts) {
      do {
        game.nextPlayer();
        playerHasAvailableContracts = game.currentPlayer.hasAvailableContracts(
          activeContracts,
        );
      } while (!playerHasAvailableContracts &&
          game.currentPlayer != firstPlayer);
    }
    game.isFinished = !playerHasAvailableContracts;
    return !game.isFinished;
  }

  /// Saves the score for the contract
  void finishContract(AbstractContractModel contract) {
    game.currentPlayer.addContract(contract);
  }

  /// Changes the current player to the next one
  /// Returns true if there is a next player, false if the game is finished
  bool nextPlayer() {
    game.nextPlayer();
    moveToFirstPlayerWithAvailableContracts();
    notifyListeners();
    storage.saveGame(game);
    return !game.isFinished;
  }
}
