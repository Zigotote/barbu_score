import 'package:barbu_score/commons/models/contract_info.dart';
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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../fake/game.dart';
import '../utils.dart';
@GenerateNiceMocks([MockSpec<MyStorage2>()])
import 'my_home_test.mocks.dart';

const startGameText = "Démarrer une partie";
const loadGameText = "Charger une partie";

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(const MaterialApp(home: MyHome()));

    expect($("Le Barbu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  group("#startGame", () {
    patrolWidgetTest("should start game if no stored game", ($) async {
      await $.pumpWidget(_createPage());

      await $(startGameText).tap();

      expect($(CreateGame), findsOneWidget);
    });
    patrolWidgetTest("should start game if finished stored game", ($) async {
      final storedGame = FakeGame(finished: true);
      await $.pumpWidget(_createPage(storedGame: storedGame));

      await $(startGameText).tap();

      expect($(CreateGame), findsOneWidget);
    });
    for (var startGame in [true, false]) {
      patrolWidgetTest(
          "should ${startGame ? "" : "not "}start game if stored game is ${startGame ? "ignored" : "loaded"}",
          ($) async {
        await $.pumpWidget(_createPage(storedGame: FakeGame()));

        await $(startGameText).tap();

        expect($(MyAlertDialog), findsOneWidget);
        if (startGame) {
          await $("Oui").tap();
          expect($(CreateGame), findsOneWidget);
        } else {
          await $("Non, reprendre la partie").tap();
          expect($(PrepareGame), findsOneWidget);
        }

        await _checkGoBack($);
      });
    }
    patrolWidgetTest("should not start game if no active contract", ($) async {
      await $.pumpWidget(_createPage(activeContracts: []));

      await $(startGameText).tap();

      expect($(MyAlertDialog), findsOneWidget);
      await $(MyAlertDialog)
          .$(ElevatedButton)
          .tap(settlePolicy: SettlePolicy.trySettle);

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

        await $(loadGameText).tap();

        expect($(MyAlertDialog), findsOneWidget);
        if (loadGame) {
          await $("Oui").tap();
          expect($(PrepareGame), findsOneWidget);
        } else {
          await $("Non, nouvelle partie").tap();
          expect($(CreateGame), findsOneWidget);
        }
        // should go back to home
        await _checkGoBack($);
      });
    }
    patrolWidgetTest("should display scores if stored game is finished",
        ($) async {
      await $.pumpWidget(_createPage(storedGame: FakeGame(finished: true)));

      await $(loadGameText).tap();

      expect($(MyAlertDialog), findsOneWidget);
      await $("Oui").tap();
      expect($(FinishGame), findsOneWidget);
    });
    patrolWidgetTest("should not load game if no stored game", ($) async {
      await $.pumpWidget(_createPage());

      await $(loadGameText).tap();

      expect($("Aucune partie trouvée"), findsOneWidget);
      expect($(CreateGame), findsOneWidget);
    });
  });
}

/// Verify go back goes to home
Future<void> _checkGoBack(PatrolTester $) async {
  await $(Icons.arrow_back).tap();
  expect($(MyHome), findsOneWidget);
}

Widget _createPage({
  Game? storedGame,
  List<ContractsInfo> activeContracts = ContractsInfo.values,
}) {
  final mockStorage = MockMyStorage2();
  when(mockStorage.getStoredGame()).thenReturn(storedGame);
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.settings;
    contractSettings.isActive = activeContracts.contains(contract);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  when(mockStorage.getActiveContracts()).thenReturn(activeContracts);
  when(mockStorage.listenContractsSettings()).thenReturn(ValueNotifier({}));

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
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
