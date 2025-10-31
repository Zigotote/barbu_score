import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../theme/my_theme_colors.dart';
import 'widgets/rules_page.dart';

class GameRoundRules extends StatelessWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GameRoundRules(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final rulesByStep = context.l10n.gameRoundRules.split("*");
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.gameRound,
      content: FixedTimeline.tileBuilder(
        builder: TimelineTileBuilder.connected(
          nodePositionBuilder: (_, _) => 0,
          connectorBuilder: (_, _, _) => Connector.solidLine(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          indicatorBuilder: (_, index) => Indicator.dot(
            size: 24,
            color: Theme.of(context).colorScheme.convertMyColor(
              MyThemeColors.values[index % MyThemeColors.values.length],
            ),
          ),
          itemCount: rulesByStep.length,
          contentsBuilder: (_, index) => Padding(
            padding: EdgeInsets.only(
              left: 8,
              bottom: index < rulesByStep.length - 1 ? 16 : 0,
            ),
            child: Text(rulesByStep[index]),
          ),
        ),
      ),
    );
  }
}
