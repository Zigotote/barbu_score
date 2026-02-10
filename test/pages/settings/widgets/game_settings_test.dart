import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/pages/settings/notifiers/change_game_settings_provider.dart';
import 'package:barbu_score/pages/settings/widgets/game_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/french_material_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/utils.mocks.dart';

const _goalKey = "goal";
const _nbTricksKey = "nbTricks";
const _deckKey = "deck";
const _withdrawnCardsKey = "withdrawnCards";

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidgetAndSettle(_createApp());

    expect($("Objectif"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should display storage values", ($) async {
    await $.pumpWidgetAndSettle(_createApp());

    expect(_findSegmentedButtonValue(_goalKey, true), findsOneWidget);
    expect(_findSegmentedButtonValue(_nbTricksKey, true), findsOneWidget);
    expect($("Type de paquet"), findsNothing);
    expect($(Key(_deckKey)), findsNothing);
    expect(
      _findSegmentedButtonValue(_withdrawnCardsKey, false),
      findsOneWidget,
    );
  });

  patrolWidgetTest("should modify goal", ($) async {
    final page = _createApp();
    await $.pumpWidgetAndSettle(page);

    await $("Score élevé").tap();
    _findSegmentedButtonValue(_goalKey, false);
    expect(
      page.container.read(changeGameSettingsProvider).goalIsMinScore,
      isFalse,
    );
  });

  patrolWidgetTest("should modify number of tricks", ($) async {
    final page = _createApp();
    await $.pumpWidgetAndSettle(page);

    await $("Optimisé").tap();
    _findSegmentedButtonValue(_nbTricksKey, false);
    expect(
      page.container.read(changeGameSettingsProvider).fixedNbTricks,
      isFalse,
    );
  });

  patrolWidgetTest("should modify deck", ($) async {
    final page = _createApp();
    await $.pumpWidgetAndSettle(page);

    // Show deck question
    await $("Optimisé").tap();
    _findSegmentedButtonValue(_deckKey, kNbCardsInDeck);

    await $("$kNbCardsInSmallDeck cartes").tap();
    _findSegmentedButtonValue(_deckKey, kNbCardsInSmallDeck);
    final newSettings = page.container.read(changeGameSettingsProvider);
    expect(newSettings.fixedNbTricks, isFalse);
    expect(newSettings.nbCardsInDeck, kNbCardsInSmallDeck);
  });

  patrolWidgetTest("should modify withdrawn cards", ($) async {
    final page = _createApp();
    await $.pumpWidgetAndSettle(page);

    await $("Aléatoires").tap();
    _findSegmentedButtonValue(_withdrawnCardsKey, true);
    expect(
      page.container.read(changeGameSettingsProvider).withdrawRandomCards,
      isTrue,
    );
  });
}

Finder _findSegmentedButtonValue(String key, Object value) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is SegmentedButton &&
        widget.key == Key(key) &&
        setEquals(widget.selected, {value}),
  );
}

UncontrolledProviderScope _createApp({GameSettings? gameSettings}) {
  final mockStorage = MockMyStorage();
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(gameSettings ?? GameSettings());

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: Scaffold(body: GameSettingsWidget())),
  );
}
