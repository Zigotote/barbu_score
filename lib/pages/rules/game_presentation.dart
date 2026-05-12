import 'package:barbu_score/commons/providers/change_game_settings.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/my_section_title.dart';
import 'package:barbu_score/pages/rules/widgets/settings/game_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/rules_page.dart';

class GamePresentation extends ConsumerWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GamePresentation(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.rules,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.presentGame),
          Text(
            ref.watch(changeGameSettingsProvider).goalIsMinScore
                ? context.l10n.presentGameGoalMinScore
                : context.l10n.presentGameGoalMaxScore,
          ),
          const SizedBox(height: 24),
          MySectionTitle(context.l10n.gamePrinciple),
          const SizedBox(height: 8),
          Text(context.l10n.gamePrincipleDetails),
          SizedBox(height: 24),
          GameSettingsWidget(),
        ],
      ),
    );
  }
}
