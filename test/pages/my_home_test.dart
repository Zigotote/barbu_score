import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/create_game/create_game.dart';
import 'package:barbu_score/pages/finish_game/finish_game.dart';
import 'package:barbu_score/pages/my_home.dart';
import 'package:barbu_score/pages/prepare_game.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../fake/game.dart';
import '../fake/storage.dart';

const startGameText = "Démarrer une partie";
const loadGameText = "Charger une partie";

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(const MaterialApp(home: MyHome()));

    expect($("Le Barbu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await expectLater($.tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater($.tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater($.tester, meetsGuideline(labeledTapTargetGuideline));
    // TODO handle this guideline
    // await expectLater($, meetsGuideline(textContrastGuideline));
  });

  group("#startGame", () {
    patrolWidgetTest("should start game if no stored game", ($) async {
      await $.pumpWidget(_createPage());

      await $.tap($(startGameText));

      expect($(CreateGame), findsOneWidget);
    });
    patrolWidgetTest("should start game if finished stored game", ($) async {
      final storedGame = FakeGame(finished: true);
      await $.pumpWidget(_createPage(storedGame: storedGame));

      await $.tap($(startGameText));

      expect($(CreateGame), findsOneWidget);
    });
    for (var startGame in [true, false]) {
      patrolWidgetTest(
          "should ${startGame ? "" : "not "}start game if stored game is ${startGame ? "ignored" : "loaded"}",
          ($) async {
        await $.pumpWidget(_createPage(storedGame: FakeGame()));

        await $.tap($(startGameText));

        expect($(MyAlertDialog), findsOneWidget);
        if (startGame) {
          await $.tap($("Oui"));
          expect($(CreateGame), findsOneWidget);
        } else {
          await $.tap($("Non, reprendre la partie"));
          expect($(PrepareGame), findsOneWidget);
        }

        await _checkGoBack($);
      });
    }
    patrolWidgetTest("should not start game if no active contract", ($) async {
      await $.pumpWidget(_createPage(hasActiveContracts: false));

      await $.tap($(startGameText));

      expect($(MyAlertDialog), findsOneWidget);
      await $.tap(
        $(MyAlertDialog).$(ElevatedButton),
        settlePolicy: SettlePolicy.trySettle,
      );

      expect($(MySettings), findsOneWidget);

      await _checkGoBack($);
    });
  });
  group("#loadGame", () {
    for (var loadGame in [true, false]) {
      patrolWidgetTest(
          "should ${loadGame ? "load" : "start"} game if stored game ${loadGame ? "exists" : "is ignored"}",
          ($) async {
        await $.pumpWidget(_createPage(storedGame: FakeGame()));

        await $.tap($(loadGameText));

        expect($(MyAlertDialog), findsOneWidget);
        if (loadGame) {
          await $.tap($("Oui"));
          expect($(PrepareGame), findsOneWidget);
        } else {
          await $.tap($("Non, nouvelle partie"));
          expect($(CreateGame), findsOneWidget);
        }
        // should go back to home
        await _checkGoBack($);
      });
    }
    patrolWidgetTest("should display scores if stored game is finished",
        ($) async {
      await $.pumpWidget(_createPage(storedGame: FakeGame(finished: true)));

      await $.tap($(loadGameText));

      expect($(MyAlertDialog), findsOneWidget);
      await $.tap($("Oui"));
      expect($(FinishGame), findsOneWidget);
    });
    patrolWidgetTest("should start game if no stored game", ($) async {
      await $.pumpWidget(_createPage());

      await $.tap($(loadGameText));

      expect($(CreateGame), findsOneWidget);
    });
  });
}

/// Verify go back goes to home
Future<void> _checkGoBack(PatrolTester $) async {
  await $.tap($(Icons.arrow_back));
  expect($(MyHome), findsOneWidget);
}

Widget _createPage({
  Game? storedGame,
  bool hasActiveContracts = true,
}) {
  final container = ProviderContainer(
    overrides: [
      storageProvider.overrideWithValue(FakeStorage(
        storedGame: storedGame,
        hasActiveContracts: hasActiveContracts,
      )),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: const MyHome(),
      routes: {
        Routes.createGame: (_) => CreateGame(),
        Routes.settings: (_) => const MySettings(),
        Routes.prepareGame: (_) {
          // Ignore overflow error because this page only works on some screen sizes
          FlutterError.onError = (FlutterErrorDetails details) {
            final exception = details.exception;
            final isOverflowError = exception is FlutterError &&
                !exception.diagnostics.any((e) => e.value
                    .toString()
                    .startsWith("A RenderFlex overflowed by"));
            if (!isOverflowError) {
              FlutterError.presentError(details);
            }
          };
          return const PrepareGame();
        },
        Routes.finishGame: (_) => const FinishGame(),
      },
    ),
  );
}
