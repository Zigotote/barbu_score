import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../../commons/providers/change_game_settings.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
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
    ref.read(logProvider).sendAnalyticEvent("rules");
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
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        final storage = ref.read(storageProvider);
        final log = ref.read(logProvider);

        final newGameSettings = ref.read(changeGameSettingsProvider);
        if (newGameSettings != storage.getGameSettings()) {
          storage.saveGameSettings(newGameSettings);
          log.info("MyRules: save new game settings $newGameSettings");
          log.sendAnalyticEvent("modify_game_settings");
        }
      },
      child: TurnPageView.builder(
        controller: ref.watch(turnPageProvider),
        itemCount: RulesPageName.values.length,
        itemBuilder: (context, index) {
          return switch (RulesPageName.values[index]) {
            RulesPageName.gamePresentation => GamePresentation(index),
            RulesPageName.prepareGame => PrepareGameRules(index),
            RulesPageName.gameRound => GameRoundRules(index),
            RulesPageName.contractRules => ContractsRules(
              index,
              isInGame: widget.startingPage != null,
            ),
          };
        },
        useOnTap: false,
        overleafColorBuilder: (_) =>
            Theme.of(context).colorScheme.greyBackground,
      ),
    );
  }
}
