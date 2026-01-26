import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/pages/rules/prepare_game_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';

void main() {
  for (var testData in [
    (nbPlayers: 3, nbCards: 24, nbDecks: 1),
    (nbPlayers: 4, nbCards: 32, nbDecks: 1),
    (nbPlayers: 5, nbCards: 40, nbDecks: 1),
    (nbPlayers: 6, nbCards: 48, nbDecks: 1),
    (nbPlayers: 7, nbCards: 56, nbDecks: 2),
    (nbPlayers: 8, nbCards: 64, nbDecks: 2),
    (nbPlayers: 9, nbCards: 72, nbDecks: 2),
    (nbPlayers: 10, nbCards: 80, nbDecks: 2),
  ]) {
    patrolWidgetTest(
      "should display game preparation for ${testData.nbPlayers} players with 52 cards",
      ($) async {
        await $.pumpWidget(_createPage());
        expect($("Préparation du jeu"), findsOneWidget);

        await $(Icons.keyboard_arrow_down).tap();
        await $("${testData.nbPlayers}").tap();

        final nbDecksText = testData.nbDecks == 1
            ? "d'un paquet"
            : "de ${testData.nbDecks} paquets";
        expect(
          $(
            "Le jeu se joue avec ${testData.nbCards} cartes (8 cartes par joueur).",
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            RegExp(
              r'Avant de jouer.*'
              '$nbDecksText'
              ' de 52 cartes.*'
              '${testData.nbPlayers}'
              r' joueurs.*\d\.',
            ),
          ),
          findsOneWidget,
        );
      },
    );
    patrolWidgetTest(
      "should display game preparation for ${testData.nbPlayers} players with 52 cards and withdrawRandomCards",
      ($) async {
        await $.pumpWidget(
          _createPage(GameSettings(withdrawRandomCards: true)),
        );

        await $(Icons.keyboard_arrow_down).tap();
        await $("${testData.nbPlayers}").tap();

        final nbDecksText = testData.nbDecks == 1
            ? "1 paquet"
            : "${testData.nbDecks} paquets";
        expect(
          $("Le jeu se joue avec $nbDecksText de 52 cartes."),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            RegExp(r'A chaque manche, les joueurs reçoivent 8 cartes chacun'),
          ),
          findsOneWidget,
        );
      },
    );
  }
  for (var testData in [
    (
      nbPlayers: 3,
      nbCardsByPlayer: 10,
      nbDecks: 1,
      hasCardsToKeepPartially: true,
    ),
    (
      nbPlayers: 4,
      nbCardsByPlayer: 8,
      nbDecks: 1,
      hasCardsToKeepPartially: false,
    ),
    (
      nbPlayers: 5,
      nbCardsByPlayer: 6,
      nbDecks: 1,
      hasCardsToKeepPartially: true,
    ),
    (
      nbPlayers: 6,
      nbCardsByPlayer: 10,
      nbDecks: 2,
      hasCardsToKeepPartially: true,
    ),
    (
      nbPlayers: 7,
      nbCardsByPlayer: 9,
      nbDecks: 2,
      hasCardsToKeepPartially: true,
    ),
    (
      nbPlayers: 8,
      nbCardsByPlayer: 8,
      nbDecks: 2,
      hasCardsToKeepPartially: false,
    ),
    (
      nbPlayers: 9,
      nbCardsByPlayer: 7,
      nbDecks: 2,
      hasCardsToKeepPartially: true,
    ),
    (
      nbPlayers: 10,
      nbCardsByPlayer: 6,
      nbDecks: 2,
      hasCardsToKeepPartially: true,
    ),
  ]) {
    patrolWidgetTest(
      "should display game preparation for ${testData.nbPlayers} players with 32 cards and optimized tricks",
      ($) async {
        await $.pumpWidget(
          _createPage(GameSettings(fixedNbTricks: null, nbCardsInDeck: 32)),
        );

        await $(Icons.keyboard_arrow_down).tap();
        await $("${testData.nbPlayers}").tap();

        final nbDecksText = testData.nbDecks == 1
            ? "d'un paquet"
            : "de ${testData.nbDecks} paquets";
        final cardsToKeepPartiallyText = testData.hasCardsToKeepPartially
            ? "et de couleur trèfle, carreau ou pique"
            : r'\d';
        expect(
          $(
            "Le jeu se joue avec ${testData.nbCardsByPlayer * testData.nbPlayers} cartes (${testData.nbCardsByPlayer} cartes par joueur).",
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            RegExp(
              r'Avant de jouer.*'
              '$nbDecksText'
              ' de 32 cartes.*'
              '${testData.nbPlayers}'
              r' joueurs.*'
              '$cardsToKeepPartiallyText'
              '.',
            ),
          ),
          findsOneWidget,
        );
      },
    );
  }
}

Widget _createPage([GameSettings? gameSettings]) {
  final mockStorage = MockMyStorage();
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(gameSettings ?? GameSettings());

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const PrepareGameRules(0)),
  );
}
