import 'package:barbu_score/pages/rules/prepare_game_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';

main() {
  for (var testData in [
    (nbPlayers: 3, nbCards: 24),
    (nbPlayers: 4, nbCards: 32),
    (nbPlayers: 5, nbCards: 40),
    (nbPlayers: 6, nbCards: 48),
  ]) {
    patrolWidgetTest(
        "should display game preparation for ${testData.nbPlayers}", ($) async {
      await $.pumpWidget(
        ProviderScope(
          child: FrenchMaterialApp(home: const PrepareGameRules(0)),
        ),
      );
      expect($("Préparation du jeu"), findsOneWidget);

      await $(Icons.keyboard_arrow_down).tap();
      await $("${testData.nbPlayers}").tap();

      expect(
        $("Le jeu se joue avec ${testData.nbCards} cartes (${testData.nbPlayers} \u00d7 8)."),
        findsOneWidget,
      );
    });
  }
}
