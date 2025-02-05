import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import 'contracts_rules.dart';
import 'game_presentation.dart';
import 'game_round_rules.dart';
import 'notifiers/turn_page.dart';
import 'prepare_game_rules.dart';

class MyRules extends ConsumerWidget {
  const MyRules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TurnPageView.builder(
      controller: ref.watch(turnPageProvider),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GamePresentation(index);
        }
        if (index == 1) {
          return PrepareGameRules(index);
        }
        if (index == 2) {
          return GameRoundRules(index);
        }
        return ContractsRules(index);
      },
      useOnTap: false,
      overleafColorBuilder: (_) => Theme.of(context).colorScheme.grey,
    );
  }
}
