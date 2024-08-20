import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/models/contract_route_argument.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Tour de ${defaultPlayerNames[0]}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  patrolWidgetTest("should create page with disabled validate scores button",
      ($) async {
    await $.pumpWidget(_createPage());

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
    final contract = OneLooserContractModel(contract: ContractsInfo.barbu);
    contract.setItemsByPlayer({
      for (var (index, player) in game.players.indexed)
        player.name: index == indexSelectedPlayer ? 1 : 0
    });

    await $.pumpWidget(_createPage(contractValues: contract));

    final modifyButton = ($.tester
            .firstWidget($(ElevatedButton).containing("Modifier les scores"))
        as ElevatedButton);
    expect(modifyButton.onPressed, isNotNull);
  });
  for (var changeSelectedPlayer in [true, false]) {
    patrolWidgetTest(
        "should validate scores if one player is selected and go to next player turn ${changeSelectedPlayer ? "with" : "without"} change of mind",
        ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final game = mockGame(mockPlayGame);
      const indexSelectedPlayer = 1;
      final expectedContract =
          OneLooserContractModel(contract: ContractsInfo.barbu);
      expectedContract.setItemsByPlayer({
        for (var (index, player) in game.players.indexed)
          player.name: index == indexSelectedPlayer ? 1 : 0
      });

      await $.pumpWidget(_createPage(mockPlayGame: mockPlayGame));

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

Widget _createPage(
    {OneLooserContractModel? contractValues,
    MockPlayGameNotifier? mockPlayGame}) {
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);

  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }
  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage)
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: OneLooserContractPage(
        ContractRouteArgument(
          contractInfo: ContractsInfo.barbu,
          contractModel: contractValues,
        ),
      ),
      routes: {Routes.chooseContract: (_) => const ChooseContract()},
    ),
  );
}
