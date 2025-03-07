import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

import 'widgets/rules_page.dart';

class GamePresentation extends StatelessWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GamePresentation(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.rules,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(context.l10n.presentGame),
          const SizedBox(height: 24),
          Text(
            context.l10n.gamePrinciple,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.gamePrincipleDetails),
        ],
      ),
    );
  }
}
