import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player.dart';
import '../notifiers/play_game.dart';
import 'list_layouts.dart';
import 'player_score_button.dart';

/// A list to display the scores of each player, sorted to have the best player at top
class OrderedPlayersScores extends ConsumerWidget {
  /// The indicator to know if it's the end of the game. If true, more info are displayed
  final bool isFinished;

  const OrderedPlayersScores({super.key, this.isFinished = false});

  /// Calculates the total score of each player for the party
  /// and orders them by score
  List<MapEntry<String, int>> _orderedPlayerScores(List<Player> players) {
    Map<String, int> playerScores = {
      for (var player in players) player.name: 0
    };
    for (var player in players) {
      player.playerScores?.forEach((playerName, score) {
        int? playerScore = playerScores[playerName];
        if (playerScore != null) {
          playerScores[playerName] = playerScore + score;
        } else {
          playerScores[playerName] = score;
        }
      });
    }
    return playerScores.entries.toList()
      ..sort(
        (player1, player2) => player1.value.compareTo(player2.value),
      );
  }

  /// Finds the player's best friend
  Player _findBestFriend(Player player, List<Player> players) {
    return _findPlayerWhere(
        players, player, (score1, score2) => score1 > score2);
  }

  /// Finds the player's worst ennemy
  Player _findWorstEnnemy(Player player, List<Player> players) {
    return _findPlayerWhere(
        players, player, (score1, score2) => score1 < score2);
  }

  /// Finds the player where condition applies
  Player _findPlayerWhere(
      List<Player> players, Player player, Function(int, int) condition) {
    int score = player.playerScores![player.name]!;
    Player playerFound = player;
    for (var p in players) {
      final int playerScore = p.playerScores![player.name]!;
      if (condition(score, playerScore)) {
        playerFound = p;
        score = playerScore;
      }
    }
    return playerFound;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(playGameProvider);
    final List<MapEntry<String, int>> orderedPlayers =
        _orderedPlayerScores(provider.players);
    return MyList(
      itemCount: provider.players.length,
      itemBuilder: (_, index) {
        final MapEntry<String, int> playerInfo = orderedPlayers[index];
        final Player player =
            provider.players.firstWhere((p) => p.name == playerInfo.key);
        return PlayerScoreButton(
          player: player,
          score: playerInfo.value,
          displayMedal: isFinished && index == 0,
          bestFriend: isFinished == false
              ? null
              : _findBestFriend(player, provider.players),
          worstEnnemy: isFinished == false
              ? null
              : _findWorstEnnemy(player, provider.players),
        );
      },
    );
  }
}
