import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import 'contracts_rules.dart';
import 'game_presentation.dart';
import 'game_round_rules.dart';
import 'models/rules_page_name.dart';
import 'notifiers/turn_page.dart';
import 'prepare_game_rules.dart';

class MyRules extends ConsumerStatefulWidget {
  final RulesPageName? startingPage;

  const MyRules({super.key, this.startingPage});

  @override
  ConsumerState<MyRules> createState() => _MyRulesState();
}

class _MyRulesState extends ConsumerState<MyRules> {
  @override
  void initState() {
    super.initState();
    final startingPage = widget.startingPage;
    if (startingPage != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref
            .read(turnPageProvider)
            .jumpToPage(RulesPageName.values.indexOf(startingPage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TurnPageView.builder(
      controller: ref.watch(turnPageProvider),
      itemCount: RulesPageName.values.length,
      itemBuilder: (context, index) {
        return switch (RulesPageName.values[index]) {
          RulesPageName.gamePresentation => GamePresentation(index),
          RulesPageName.prepareGame => PrepareGameRules(index),
          RulesPageName.gameRound => GameRoundRules(index),
          RulesPageName.contractRules =>
            ContractsRules(index, isInGame: widget.startingPage != null),
        };
      },
      useOnTap: false,
      overleafColorBuilder: (_) => Theme.of(context).colorScheme.grey,
    );
  }
}
