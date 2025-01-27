import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/providers/storage.dart';
import '../commons/utils/snackbar.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_appbar.dart';
import '../commons/widgets/ordered_players_scores.dart';
import '../main.dart';

/// A page to display the scores of each player for the game
class MyScores extends ConsumerWidget {
  const MyScores({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultPage(
      appBar: MyAppBar(context.l10n.scores, context: context, hasLeading: true),
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
          child: Text(context.l10n.saveAndLeave),
          onPressed: () {
            final game = ref.read(playGameProvider).game;
            ref.read(logProvider).info("MyScores: save $game");
            ref.read(logProvider).sendAnalyticEvent(
              "save_game",
              parameters: {"nbPlayers": game.players.length},
            );
            ref.read(storageProvider).saveGame(game);
            Navigator.of(context).popAndPushNamed(Routes.home);
            SnackBarUtils.instance.openSnackBar(
              context: context,
              title: context.l10n.gameSaved,
              text: context.l10n.loadGameIndication,
            );
          }),
    );
  }
}
