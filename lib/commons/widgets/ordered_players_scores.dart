import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player.dart';
import '../providers/contracts_manager.dart';
import '../providers/play_game.dart';
import '../utils/contract_scores.dart';
import 'my_list_layouts.dart';
import 'player_score_button.dart';

/// A list to display the scores of each player, sorted to have the best player at top
class OrderedPlayersScores extends ConsumerWidget {
  /// Indicates if the gme is finished or not
  final bool isGameFinished;

  const OrderedPlayersScores({super.key, this.isGameFinished = false});

  /// Calculates the total score of each player for the game
  /// and orders them by score
  List<MapEntry<String, int>> _orderedPlayerScores(
      Map<Player, Map<String, int>?> scoresByPlayer,) {
    final totalScores = sumScores(scoresByPlayer.values.toList());
    final playerScores =
        totalScores ?? {for (var player in scoresByPlayer.keys) player.name: 0};
    return playerScores.entries.toList()
      ..sort((player1, player2) => player1.value.compareTo(player2.value));
  }

  /// Finds the player's best friend
  Player _findBestFriend(Player player,
      Map<Player, Map<String, int>?> scoresByPlayer,) {
    return _findPlayerWhere(
      player,
      scoresByPlayer,
          (score1, score2) => score1 > score2,
    );
  }

  /// Finds the player's worst ennemy
  Player _findWorstEnnemy(Player player,
      Map<Player, Map<String, int>?> scoresByPlayer,) {
    return _findPlayerWhere(
      player,
      scoresByPlayer,
          (score1, score2) => score1 < score2,
    );
  }

  /// Finds the player where condition applies
  Player _findPlayerWhere(Player player,
      Map<Player, Map<String, int>?> scoresByPlayer,
      Function(int, int) condition,) {
    int? score = scoresByPlayer[player]?[player.name];
    Player playerFound = player;
    for (var scores in scoresByPlayer.entries) {
      final playerScore = scores.value?[player.name];
      if (score == null ||
          (playerScore != null && condition(score, playerScore))) {
        playerFound = scores.key;
        score = playerScore;
      }
    }
    return playerFound;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref
        .read(playGameProvider)
        .players;
    final contractsManager = ref.read(contractsManagerProvider);
    final Map<Player, Map<String, int>?> scoresByPlayer = {
      for (var player in players)
        player: sumScores(
          contractsManager
              .scoresByContract(player)
              .values
              .toList(),
        ),
    };
    final List<MapEntry<String, int>> orderedPlayers = _orderedPlayerScores(
      scoresByPlayer,
    );
    return MyList(
      itemCount: players.length,
      itemBuilder: (_, index) {
        final MapEntry<String, int> playerInfo = orderedPlayers[index];
        final Player player = players.firstWhere(
              (p) => p.name == playerInfo.key,
        );
        return PlayerScoreButton(
          player: player,
          score: playerInfo.value,
          displayMedal:
          isGameFinished && playerInfo.value == orderedPlayers[0].value,
          bestFriend: isGameFinished
              ? _findBestFriend(player, scoresByPlayer)
              : null,
          worstEnnemy: isGameFinished
              ? _findWorstEnnemy(player, scoresByPlayer)
              : null,
        );
      },
    );
  }
}
