import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../commons/models/player.dart';
import '../commons/utils/snackbar.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/player_score_button.dart';
import '../main.dart';

/// A page to display the scores of each player for the party
class MyScores extends ConsumerWidget {
  const MyScores({super.key});

  /// Calculates the total score of each player for the party
  /// and orders them by score
  List<MapEntry<String, int>> orderedPlayerScores(List<Player> players) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    final List<MapEntry<String, int>> orderedPlayers =
        orderedPlayerScores(players);
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: MyList(
        itemCount: players.length,
        itemBuilder: (_, index) {
          MapEntry<String, int> playerInfo = orderedPlayers[index];
          Player player = players.firstWhere((p) => p.name == playerInfo.key);
          return PlayerScoreButton(
            player: player,
            score: playerInfo.value,
          );
        },
      ),
      bottomWidget: ElevatedButton(
          child: const Text('Sauvegarder et quitter'),
          onPressed: () {
            //MyStorage().saveParty();
            context.go(Routes.home);
            SnackbarUtils.instance.openSnackBar(
              context: context,
              title: "Partie sauvegardée",
              text: "Sélectionnez 'Charger une partie' pour la poursuivre.",
            );
          }),
    );
  }
}
