import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
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
  patrolWidgetTest("should create page with disabled validate scores button",
      ($) async {
    await $.pumpWidget(_createPage($));

    expect($(ElevatedButtonCustomColor), findsNWidgets(nbPlayersByDefault));
    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNull);
  });
  patrolWidgetTest("should create page with initial selected player",
      ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    const indexSelectedPlayer = 1;
    final contract = OneLooserContractModel(
      contract: ContractsInfo.barbu,
      itemsByPlayer: {
        for (var (index, player) in game.players.indexed)
          player.name: index == indexSelectedPlayer ? 1 : 0
      },
    );

    await $.pumpWidget(_createPage($, contractValues: contract));

    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNotNull);
  });
  for (var changeSelectedPlayer in [true, false]) {
    patrolWidgetTest(
        "should validate scores if one player is selected and go to next player turn ${changeSelectedPlayer ? "with" : "without"} change of mind",
        ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final game = mockGame(mockPlayGame);
      const indexSelectedPlayer = 1;
      final expectedContract = OneLooserContractModel(
        contract: ContractsInfo.barbu,
        itemsByPlayer: {
          for (var (index, player) in game.players.indexed)
            player.name: index == indexSelectedPlayer ? 1 : 0
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
    });
  }
}

Widget _createPage(PatrolTester $,
    {OneLooserContractModel? contractValues,
    MockPlayGameNotifier? mockPlayGame}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

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
            builder: (_, __) => OneLooserContractPage(
              ContractsInfo.barbu,
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
