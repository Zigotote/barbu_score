import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/commons/widgets/my_default_page.dart';
import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:barbu_score/pages/finish_game/widgets/game_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../commons/providers/log.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../main.dart';

/// A page to display the scores of each player at the end of the game
class FinishGame extends ConsumerWidget {
  const FinishGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(logProvider).info("FinishGame: finished game");
    ref.read(logProvider).sendAnalyticEvent("finish_game");
    final goHomeButton = ElevatedButtonFullWidth(
      child: Text(context.l10n.goHome, textAlign: TextAlign.center),
      onPressed: () {
        WakelockPlus.disable();
        context.go(Routes.home);
      },
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(
          Text(context.l10n.endGame),
          context: context,
          tabs: [
            Tab(text: context.l10n.ranking),
            Tab(text: context.l10n.scoresByContract),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              MyScrollView(
                content: OrderedPlayersScores(isGameFinished: true),
                bottomWidget: goHomeButton,
              ),
              Padding(
                padding: MyDefaultPage.appPadding,
                child: Column(
                  spacing: 16,
                  children: [
                    Expanded(child: GameTable()),
                    goHomeButton,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
