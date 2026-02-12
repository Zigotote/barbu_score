import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/widgets/discarded_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Tour de"), findsOneWidget);
    expect($(defaultPlayerNames[0]), findsNWidgets(2));
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should open and close contract rules", ($) async {
    await $.pumpWidget(_createPage($));

    await $.tap($(Icons.question_mark_outlined));
    expect($(DraggableScrollableSheet), findsOneWidget);
    expect($("Règles Barbu"), findsOneWidget);

    await $.tap($(Icons.close));
    expect($(DraggableScrollableSheet), findsNothing);
  });

  group("#discardedCards", () {
    patrolWidgetTest(
      "should create page without discarded cards field if no random cards are removed",
      ($) async {
        await $.pumpWidget(_createPage($));

        expect($(ElevatedButtonCustomColor), findsNWidgets(nbPlayersByDefault));
        expect($(DiscardedCards), findsNothing);
        expect(findValidateScoresButtonWidget($).onPressed, isNull);
      },
    );
    patrolWidgetTest(
      "should create page without discarded cards field if no cards are discarded from the deck",
      ($) async {
        await $.pumpWidget(
          _createPage(
            $,
            gameSettings: GameSettings(
              discardRandomCards: true,
              fixedNbTricks: false,
            ),
          ),
        );

        expect($(DiscardedCards), findsNothing);
      },
    );
    patrolWidgetTest(
      "should create page with discarded cards field if random cards can be removed",
      ($) async {
        await $.pumpWidget(
          _createPage($, gameSettings: GameSettings(discardRandomCards: true)),
        );

        expect($(DiscardedCards).containing("0"), findsOneWidget);
      },
    );
  });

  group("#isNotValid", () {
    patrolWidgetTest(
      "should create page with disabled validate scores button",
      ($) async {
        await $.pumpWidget(_createPage($));

        expect($(ElevatedButtonCustomColor), findsNWidgets(nbPlayersByDefault));
        expect(findValidateScoresButtonWidget($).onPressed, isNull);
      },
    );
  });

  group("#isValid", () {
    patrolWidgetTest("should create page with discarded card", ($) async {
      final mockPlayGame = mockPlayGameNotifier();
      final game = mockPlayGame.game;
      final contract = ContractWithPointsModel(
        contract: ContractsInfo.barbu,
        itemsByPlayer: {for (var player in game.players) player.name: 0},
      );

      await $.pumpWidget(
        _createPage(
          $,
          contractValues: contract,
          gameSettings: GameSettings(discardRandomCards: true),
        ),
      );

      expect(findValidateScoresButtonWidget($).onPressed, isNotNull);
      expect($(DiscardedCards).containing("1"), findsOneWidget);
    });

    patrolWidgetTest("should create page with initial selected player", (
      $,
    ) async {
      final mockPlayGame = mockPlayGameNotifier();
      final game = mockPlayGame.game;
      const indexSelectedPlayer = 1;
      final contract = ContractWithPointsModel(
        contract: ContractsInfo.barbu,
        itemsByPlayer: {
          for (var (index, player) in game.players.indexed)
            player.name: index == indexSelectedPlayer ? 1 : 0,
        },
      );

      await $.pumpWidget(_createPage($, contractValues: contract));

      expect(findValidateScoresButtonWidget($).onPressed, isNotNull);
    });

    for (var changeSelectedPlayer in [true, false]) {
      patrolWidgetTest(
        "should validate scores if one player is selected and go to next player turn ${changeSelectedPlayer ? "with" : "without"} change of mind",
        ($) async {
          final mockPlayGame = mockPlayGameNotifier();
          final game = mockPlayGame.game;
          const indexSelectedPlayer = 1;
          final expectedContract = ContractWithPointsModel(
            contract: ContractsInfo.barbu,
            itemsByPlayer: {
              for (var (index, player) in game.players.indexed)
                player.name: index == indexSelectedPlayer ? 1 : 0,
            },
          );

          await $.pumpWidget(_createPage($, mockPlayGame: mockPlayGame));

          if (changeSelectedPlayer) {
            await $(ElevatedButtonCustomColor).at(0).tap();
          }
          await $(ElevatedButtonCustomColor).at(indexSelectedPlayer).tap();
          await findValidateScoresButton($).tap();

          expect($(ChooseContract), findsOneWidget);
          verify(mockPlayGame.finishContract(expectedContract));
          verify(mockPlayGame.nextPlayer());
        },
      );
    }
    for (var cardIsDiscarded in [true, false]) {
      patrolWidgetTest(
        "should validate scores if card is ${cardIsDiscarded ? 'discarded' : 'kept'} and go to next player turn",
        ($) async {
          final mockPlayGame = mockPlayGameNotifier();
          final game = mockPlayGame.game;
          final indexSelectedPlayer = cardIsDiscarded ? -1 : 1;
          final expectedContract = ContractWithPointsModel(
            contract: ContractsInfo.barbu,
            itemsByPlayer: {
              for (var (index, player) in game.players.indexed)
                player.name: index == indexSelectedPlayer ? 1 : 0,
            },
          );

          await $.pumpWidget(
            _createPage(
              $,
              mockPlayGame: mockPlayGame,
              gameSettings: GameSettings(discardRandomCards: true),
            ),
          );

          if (cardIsDiscarded) {
            await $(ElevatedButtonCustomColor).at(0).tap();
            await $(Icons.add).tap();
          } else {
            await $(Icons.add).tap();
            await $(ElevatedButtonCustomColor).at(indexSelectedPlayer).tap();
          }
          expect(
            $(DiscardedCards).containing(cardIsDiscarded ? "1" : "0"),
            findsOneWidget,
          );

          await findValidateScoresButton($).tap();

          expect($(ChooseContract), findsOneWidget);
          verify(mockPlayGame.finishContract(expectedContract));
          verify(mockPlayGame.nextPlayer());
        },
      );
    }
  });
}

Widget _createPage(
  PatrolTester $, {
  ContractWithPointsModel? contractValues,
  MockPlayGameNotifier? mockPlayGame,
  GameSettings? gameSettings,
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(gameSettings ?? GameSettings());

  mockPlayGame ??= mockPlayGameNotifier();
  final container = ProviderContainer(
    overrides: [
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (_, _) => OneLooserContractPage(
              ContractsInfo.barbu,
              contractModel: contractValues,
            ),
          ),
          GoRoute(
            path: Routes.chooseContract,
            builder: (_, _) => const ChooseContract(),
          ),
        ],
      ),
    ),
  );
}
