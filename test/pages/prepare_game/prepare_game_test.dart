import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/pages/prepare_game/prepare_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Préparer la partie"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var nbPlayers = kNbPlayersMin; nbPlayers <= kNbPlayersMax; nbPlayers++) {
    patrolWidgetTest("should display $nbPlayers players", ($) async {
      await $.pumpWidget(_createPage($, nbPlayers: nbPlayers));

      for (var (index, player) in defaultPlayerNames.indexed) {
        expect($(player), index < nbPlayers ? findsOneWidget : findsNothing);
      }
    });
  }
  group("deck text", () {
    for (var hasDiscardedCards in [true, false]) {
      patrolWidgetTest(
        "should display text when discardRandomCards${hasDiscardedCards ? ' with discarded cards' : ''}",
        ($) async {
          await $.pumpWidget(
            _createPage(
              $,
              gameSettings: GameSettings(
                discardRandomCards: true,
                fixedNbTricks: hasDiscardedCards,
              ),
            ),
          );

          expect($("Mélanger"), findsOneWidget);
          expect($("1 paquet de $kNbCardsInDeck cartes."), findsOneWidget);
          expect(
            $("Défausser 20 cartes."),
            hasDiscardedCards ? findsOneWidget : findsNothing,
          );
        },
      );
    }
    for (var testData in [
      (nbPlayers: 3, nbDecks: 1, cardsToKeep: "2♥♦♣ et 3 à As"),
      (nbPlayers: 4, nbDecks: 1, cardsToKeep: "2 à As"),
      (nbPlayers: 5, nbDecks: 1, cardsToKeep: "2♥♦ et 3 à As"),
      (nbPlayers: 6, nbDecks: 1, cardsToKeep: "3 à As"),
      (nbPlayers: 7, nbDecks: 1, cardsToKeep: "2♥ et 3 à As"),
      (nbPlayers: 8, nbDecks: 1, cardsToKeep: "3 à As"),
      (nbPlayers: 9, nbDecks: 2, cardsToKeep: "2♥♦♣ et 3 à As"),
      (nbPlayers: 10, nbDecks: 2, cardsToKeep: "2♥♦ et 3 à As"),
    ]) {
      patrolWidgetTest(
        "should display game preparation for ${testData.nbPlayers} players with $kNbCardsInDeck cards and optimized tricks",
        ($) async {
          await $.pumpWidget(
            _createPage(
              $,
              nbPlayers: testData.nbPlayers,
              gameSettings: GameSettings(fixedNbTricks: false),
            ),
          );

          expect($(testData.cardsToKeep), findsOneWidget);
          expect(
            $("du paquet."),
            testData.nbDecks == 1 ? findsOneWidget : findsNothing,
          );
          expect(
            $("de ${testData.nbDecks} paquets."),
            testData.nbDecks == 1 ? findsNothing : findsOneWidget,
          );
        },
      );
    }
    for (var testData in [
      (nbPlayers: 3, nbDecks: 1, cardsToKeep: "7♥♦ et 8 à As"),
      (nbPlayers: 4, nbDecks: 1, cardsToKeep: "7 à As"),
      (nbPlayers: 5, nbDecks: 1, cardsToKeep: "7♥♦ et 8 à As"),
      (nbPlayers: 6, nbDecks: 2, cardsToKeep: "7♥♦ et 8 à As"),
      (nbPlayers: 7, nbDecks: 2, cardsToKeep: "7♥♦♣ et un ♠ et 8 à As"),
      (nbPlayers: 8, nbDecks: 2, cardsToKeep: "7 à As"),
      (nbPlayers: 9, nbDecks: 2, cardsToKeep: "7♥♦♣ et un ♠ et 8 à As"),
      (nbPlayers: 10, nbDecks: 2, cardsToKeep: "7♥♦ et 8 à As"),
    ]) {
      patrolWidgetTest(
        "should display game preparation for ${testData.nbPlayers} players with $kNbCardsInSmallDeck cards and optimized tricks",
        ($) async {
          await $.pumpWidget(
            _createPage(
              $,
              nbPlayers: testData.nbPlayers,
              gameSettings: GameSettings(
                fixedNbTricks: false,
                nbCardsInDeck: kNbCardsInSmallDeck,
              ),
            ),
          );

          expect($(testData.cardsToKeep), findsOneWidget);
          expect(
            $("du paquet."),
            testData.nbDecks == 1 ? findsOneWidget : findsNothing,
          );
          expect(
            $("de ${testData.nbDecks} paquets."),
            testData.nbDecks == 1 ? findsNothing : findsOneWidget,
          );
        },
      );
    }
  });
}

Widget _createPage(
  PatrolTester $, {
  int nbPlayers = nbPlayersByDefault,
  GameSettings? gameSettings,
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final mockPlayGame = mockPlayGameNotifier(nbPlayers: nbPlayers);
  final mockStorage = MockMyStorage();
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(gameSettings ?? GameSettings());

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const PrepareGame()),
  );
}
