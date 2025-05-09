import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Tour de ${defaultPlayerNames[0]}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  group("#isNotValid", () {
    patrolWidgetTest("should create page with disabled validate scores button",
        ($) async {
      await $.pumpWidget(_createPage());

      expect($("0"), findsNWidgets(nbPlayersByDefault));
      expect(_findValidateScoresButtonWidget($).onPressed, isNull);
    });
    patrolWidgetTest("should disable validation if items are withdrawn",
        ($) async {
      await $.pumpWidget(_createPage());

      for (var i = 0; i < 4; i++) {
        await $(ElevatedButtonCustomColor).containing($(Icons.add)).at(0).tap();
      }
      expect(_findValidateScoresButtonWidget($).onPressed, isNotNull);

      await $(ElevatedButtonCustomColor)
          .containing($(Icons.remove))
          .at(0)
          .tap();
      expect(_findValidateScoresButtonWidget($).onPressed, isNull);
    });
    patrolWidgetTest("should not go bellow zero", ($) async {
      await $.pumpWidget(_createPage());

      await $(ElevatedButtonCustomColor)
          .containing($(Icons.remove))
          .at(0)
          .tap();
      expect($("0"), findsNWidgets(nbPlayersByDefault));
    });
  });

  group("#isValid", () {
    patrolWidgetTest("should create page with initial scores", ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final game = mockGame(mockPlayGame);
      final contract = MultipleLooserContractModel(
        contract: ContractsInfo.noQueens,
        itemsByPlayer: {
          for (var (index, player) in game.players.indexed)
            player.name: index % 2 == 0 ? 2 : 0
        },
        nbItems: 4,
      );

      await $.pumpWidget(_createPage(contractValues: contract));

      expect($("2"), findsNWidgets(2));
      expect($("0"), findsNWidgets(2));
      final modifyButton = ($.tester
              .firstWidget($(ElevatedButton).containing("Modifier les scores"))
          as ElevatedButton);
      expect(modifyButton.onPressed, isNotNull);
    });
    for (var tooManyTap in [true, false]) {
      patrolWidgetTest(
          "should validate scores if number of items is correct, ${tooManyTap ? "with" : "without"} too many taps",
          ($) async {
        final mockPlayGame = MockPlayGameNotifier();
        final game = mockGame(mockPlayGame);
        const indexPlayerWithItems = 0;
        const nbItems = 4;
        final expectedContract = MultipleLooserContractModel(
          contract: ContractsInfo.noQueens,
          nbItems: nbItems,
        );
        expectedContract.setItemsByPlayer({
          for (var (index, player) in game.players.indexed)
            player.name: index == indexPlayerWithItems ? nbItems : 0
        });

        await $.pumpWidget(_createPage(mockPlayGame: mockPlayGame));

        for (var i = 0; i < (tooManyTap ? nbItems + 1 : nbItems); i++) {
          await $(ElevatedButtonCustomColor)
              .containing($(Icons.add))
              .at(indexPlayerWithItems)
              .tap();
        }
        expect($("Ajout de points impossible"),
            tooManyTap ? findsOneWidget : findsNothing);
        expect($("$nbItems"), findsOneWidget);
        expect($("0"), findsNWidgets(game.players.length - 1));
        await findValidateScoresButton($).tap();

        expect($(ChooseContract), findsOneWidget);
        verify(mockPlayGame.finishContract(expectedContract));
        verify(mockPlayGame.nextPlayer());
      });
    }
  });
}

ElevatedButton _findValidateScoresButtonWidget(PatrolTester $) {
  return $.tester.firstWidget(findValidateScoresButton($));
}

Widget _createPage(
    {MultipleLooserContractModel? contractValues,
    MockPlayGameNotifier? mockPlayGame}) {
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);

  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }
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
            builder: (_, __) => MultipleLooserContractPage(
              ContractsInfo.noQueens,
              contractModel: contractValues,
            ),
          ),
          GoRoute(
            path: Routes.chooseContract,
            builder: (_, __) => const ChooseContract(),
          )
        ],
      ),
    ),
  );
}
