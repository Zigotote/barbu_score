import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/snackbar.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
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

final _defaultNbItems = 4;

void main() {
  // The state of the singleton is shared during tests so the snackbar cannot be opened multiple times
  tearDown(() => SnackBarUtils.instance.isSnackBarOpen = false);

  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Tour de"), findsOneWidget);
    expect($(defaultPlayerNames[0]), findsNWidgets(2));
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should open and close contract rules", ($) async {
    await $.pumpWidget(_createPage());

    await $.tap($(Icons.question_mark_outlined));
    expect($(DraggableScrollableSheet), findsOneWidget);
    expect($("Règles Sans dames"), findsOneWidget);

    await $.tap($(Icons.close));
    expect($(DraggableScrollableSheet), findsNothing);
  });

  group("#isNotValid", () {
    patrolWidgetTest(
      "should create page with disabled validate scores button",
      ($) async {
        await $.pumpWidget(_createPage());

        expect($("0"), findsNWidgets(nbPlayersByDefault));
        expect(findValidateScoresButtonWidget($).onPressed, isNull);
      },
    );
    patrolWidgetTest("should disable validation if items are discarded", (
      $,
    ) async {
      await $.pumpWidget(_createPage());

      for (var i = 0; i < 4; i++) {
        await $(IconButton).containing($(Icons.add)).at(0).tap();
      }
      expect(findValidateScoresButtonWidget($).onPressed, isNotNull);

      await $(IconButton).containing($(Icons.remove)).at(0).tap();
      expect(findValidateScoresButtonWidget($).onPressed, isNull);
    });
    patrolWidgetTest("should not go bellow zero", ($) async {
      await $.pumpWidget(_createPage());

      await $(IconButton).containing($(Icons.remove)).at(0).tap();
      expect($("0"), findsNWidgets(nbPlayersByDefault));
    });
    patrolWidgetTest("should not go above max number of items", ($) async {
      await $.pumpWidget(_createPage());

      for (var i = 0; i < _defaultNbItems + 1; i++) {
        await $(IconButton).containing($(Icons.add)).at(0).tap();
      }
      expect($("Ajout d'élément impossible"), findsOneWidget);
      expect($("$_defaultNbItems"), findsOneWidget);
    });
  });

  group("#discardedCards", () {
    patrolWidgetTest(
      "should create page without discarded cards field if no random cards can be removed",
      ($) async {
        await $.pumpWidget(_createPage());

        expect($(DiscardedCards), findsNothing);
      },
    );
    patrolWidgetTest(
      "should create page without discarded cards field if no cards are discarded from the deck",
      ($) async {
        await $.pumpWidget(
          _createPage(
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
          _createPage(gameSettings: GameSettings(discardRandomCards: true)),
        );

        expect($(DiscardedCards), findsOneWidget);
        expect($("0"), findsNWidgets(nbPlayersByDefault + 1));
      },
    );
    patrolWidgetTest(
      "should not add more discarded items than max number of items",
      ($) async {
        await $.pumpWidget(
          _createPage(gameSettings: GameSettings(discardRandomCards: true)),
        );

        for (var i = 0; i < _defaultNbItems + 1; i++) {
          await $(IconButton).containing($(Icons.add)).last.tap();
        }
        await $.pump();
        expect($("Ajout d'élément impossible"), findsOneWidget);
        expect($("$_defaultNbItems"), findsOneWidget);
      },
    );
    patrolWidgetTest(
      "should not add more discarded items than max number of discarded cards",
      ($) async {
        await $.pumpWidget(
          _createPage(
            contract: ContractsInfo.noHearts,
            nbPlayers: 5,
            gameSettings: GameSettings(
              discardRandomCards: true,
              fixedNbTricks: false,
            ),
          ),
        );
        final nbDiscardedCards = 2;

        for (var i = 0; i < nbDiscardedCards + 1; i++) {
          await $(IconButton).containing($(Icons.add)).last.tap();
        }
        await $.pump();
        expect($("Ajout de carte défaussée impossible"), findsOneWidget);
        expect($("$nbDiscardedCards"), findsOneWidget);
      },
    );
  });

  group("#isValid", () {
    for (var discardRandomCards in [true, false]) {
      final discardedCardsText = discardRandomCards
          ? "with discarded cards"
          : "";
      patrolWidgetTest(
        "should create page with initial items $discardedCardsText",
        ($) async {
          final mockPlayGame = mockPlayGameNotifier();
          final game = mockPlayGame.game;
          final contract = ContractWithPointsModel(
            contract: ContractsInfo.noQueens,
            itemsByPlayer: {
              for (var (index, player) in game.players.indexed)
                player.name: index % 2 == 0
                    ? discardRandomCards
                          ? 1
                          : 2
                    : 0,
            },
            nbItems: 4,
          );

          await $.pumpWidget(
            _createPage(
              contractValues: contract,
              gameSettings: GameSettings(
                discardRandomCards: discardRandomCards,
              ),
            ),
          );

          expect($("1"), discardRandomCards ? findsNWidgets(2) : findsNothing);
          expect($("2"), findsNWidgets(discardRandomCards ? 1 : 2));
          expect($("0"), findsNWidgets(2));
          final validateButton =
              ($.tester.firstWidget(findValidateScoresButton($))
                  as ElevatedButton);
          expect(validateButton.onPressed, isNotNull);
        },
      );
      patrolWidgetTest(
        "should validate scores if number of items is correct $discardedCardsText",
        ($) async {
          final mockPlayGame = mockPlayGameNotifier();
          final game = mockPlayGame.game;
          const indexPlayerWithItems = 0;
          final nbItemsForPlayer = discardRandomCards ? 1 : _defaultNbItems;
          final nbDiscardedCards = _defaultNbItems - nbItemsForPlayer;
          final expectedContract = ContractWithPointsModel(
            contract: ContractsInfo.noQueens,
            nbItems: _defaultNbItems,
            itemsByPlayer: {
              for (var (index, player) in game.players.indexed)
                player.name: index == indexPlayerWithItems
                    ? nbItemsForPlayer
                    : 0,
            },
          );

          await $.pumpWidget(
            _createPage(
              mockPlayGame: mockPlayGame,
              gameSettings: GameSettings(
                discardRandomCards: discardRandomCards,
              ),
            ),
          );

          for (var i = 0; i < nbItemsForPlayer; i++) {
            await $(
              IconButton,
            ).containing($(Icons.add)).at(indexPlayerWithItems).tap();
          }
          for (var i = 0; i < nbDiscardedCards; i++) {
            await $(IconButton).containing($(Icons.add)).last.tap();
          }
          expect($("Ajout d'éléments impossible"), findsNothing);
          expect($("$nbItemsForPlayer"), findsOneWidget);
          expect($("0"), findsNWidgets(game.players.length - 1));
          if (discardRandomCards) {
            expect($("$nbDiscardedCards"), findsOneWidget);
          }
          await findValidateScoresButton($).tap();

          expect($(ChooseContract), findsOneWidget);
          verify(mockPlayGame.finishContract(expectedContract));
          verify(mockPlayGame.nextPlayer());
        },
      );
    }
  });
}

Widget _createPage({
  ContractsInfo contract = ContractsInfo.noQueens,
  ContractWithPointsModel? contractValues,
  MockPlayGameNotifier? mockPlayGame,
  int nbPlayers = nbPlayersByDefault,
  GameSettings? gameSettings,
}) {
  final mockStorage = MockMyStorage();
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(gameSettings ?? GameSettings());
  mockActiveContracts(mockStorage);

  mockPlayGame ??= mockPlayGameNotifier(nbPlayers: nbPlayers);
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
            builder: (_, _) => MultipleLooserContractPage(
              contract,
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
