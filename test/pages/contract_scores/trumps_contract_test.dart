import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/models/contract_route_argument.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/notifiers/trumps_provider.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/trumps_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Quel est le score de chaque contrat ?"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var activeContracts in [
    TrumpsContractSettings.availableContracts,
    [ContractsInfo.barbu],
    [ContractsInfo.noQueens, ContractsInfo.barbu]
  ]) {
    patrolWidgetTest(
        "should create page with unfilled contracts $activeContracts",
        ($) async {
      await $.pumpWidget(
        _createPage(
          $,
          settings: TrumpsContractSettings(
            contracts: Map.fromIterable(
              TrumpsContractSettings.availableContracts,
              value: (contract) => activeContracts.contains(contract),
            ),
          ),
        ),
      );

      for (var contract in TrumpsContractSettings.availableContracts) {
        expect(
          $(contract.displayName),
          activeContracts.contains(contract) ? findsOneWidget : findsNothing,
        );
      }
      expect($(Icons.task_alt_outlined), findsNothing);
      final validateButton =
          ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
      expect(validateButton.onPressed, isNull);
    });
  }
  for (var contractToFill in TrumpsContractSettings.availableContracts) {
    patrolWidgetTest("should fill $contractToFill sub contract", ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final page = _createPage($, mockPlayGame: mockPlayGame);
      await $.pumpWidget(page);

      expect(page.container.read(trumpsProvider).model.subContracts, isEmpty);
      final subContractModel = page.container
          .read(contractsManagerProvider)
          .getContractManager(contractToFill)
          .model as AbstractSubContractModel;
      await _fillSubContract($, mockPlayGame, contractToFill, subContractModel);

      // Redirect to trumps contract page
      expect($(TrumpsContractPage), findsOneWidget);
      expect($(ElevatedButtonWithIndicator), findsOneWidget);
      expect(
          $(ElevatedButtonWithIndicator).containing(contractToFill.displayName),
          findsOneWidget);
      final validateButton =
          ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
      expect(validateButton.onPressed, isNull);

      // Verifies the contract has been saved
      final savedTrumpsContracts =
          page.container.read(trumpsProvider).model.subContracts;
      expect(savedTrumpsContracts.length, 1);
      expect(savedTrumpsContracts.first, subContractModel);
    });
  }
  patrolWidgetTest("should modify sub contract", ($) async {
    const contract = ContractsInfo.barbu;
    final mockPlayGame = MockPlayGameNotifier();
    final page = _createPage($, mockPlayGame: mockPlayGame);
    final playerSelectedAfterModify = mockPlayGame.players.length - 1;
    final expectedSubContract = OneLooserContractModel(contract: contract);
    expectedSubContract.setItemsByPlayer({
      for (var (index, player) in mockPlayGame.players.indexed)
        player.name: index == playerSelectedAfterModify ? 1 : 0
    });

    await $.pumpWidget(page);

    expect(page.container.read(trumpsProvider).model.subContracts, isEmpty);
    await _fillSubContract(
      $,
      mockPlayGame,
      contract,
      page.container
          .read(contractsManagerProvider)
          .getContractManager(contract)
          .model as AbstractSubContractModel,
    );

    // Redirect to trumps contract page
    expect($(TrumpsContractPage), findsOneWidget);

    // Modify contract
    await $(contract.displayName).tap();
    await $(ElevatedButtonCustomColor).at(playerSelectedAfterModify).tap();
    await $(ElevatedButton).containing("Modifier les scores").tap();

    // Redirect to trumps contract page
    expect($(ElevatedButtonWithIndicator), findsOneWidget);
    expect($(ElevatedButtonWithIndicator).containing(contract.displayName),
        findsOneWidget);
    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNull);

    // Verifies the contract has been saved
    final savedTrumpsContracts =
        page.container.read(trumpsProvider).model.subContracts;
    expect(savedTrumpsContracts.length, 1);
    expect(savedTrumpsContracts.first, expectedSubContract);
  });
  patrolWidgetTest("should validate when all contracts are filled", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final page = _createPage($, mockPlayGame: mockPlayGame);
    final List<AbstractSubContractModel> subContracts = [];
    await $.pumpWidget(page);

    for (var contract in TrumpsContractSettings.availableContracts) {
      final subContractModel = page.container
          .read(contractsManagerProvider)
          .getContractManager(contract)
          .model as AbstractSubContractModel;
      await _fillSubContract($, mockPlayGame, contract, subContractModel);
      subContracts.add(subContractModel);
    }

    // Redirect to trumps contract page
    expect($(TrumpsContractPage), findsOneWidget);
    expect($(ElevatedButtonWithIndicator),
        findsNWidgets(TrumpsContractSettings.availableContracts.length));
    await findValidateScoresButton($).tap();

    expect($(ChooseContract), findsOneWidget);
    verify(
      mockPlayGame.finishContract(
        TrumpsContractModel(subContracts: subContracts),
      ),
    );
    verify(mockPlayGame.nextPlayer());
  });
}

/// Fills the subContract and modifies the [contractModel] accordingly
Future<void> _fillSubContract(PatrolTester $, MockPlayGameNotifier game,
    ContractsInfo contract, AbstractSubContractModel contractModel) async {
  const playerWithItems = 0;
  final nbItems = (contractModel is MultipleLooserContractModel)
      ? contractModel.nbItems
      : 1;
  contractModel.setItemsByPlayer({
    for (var (index, player) in game.players.indexed)
      player.name: index == playerWithItems ? nbItems : 0
  });
  // Navigate to contract
  await $(contract.displayName).tap();

  // Fill contract
  if (contractModel is OneLooserContractModel) {
    expect($(OneLooserContractPage), findsOneWidget);
    await $(ElevatedButtonCustomColor).at(playerWithItems).tap();
  } else {
    expect($(MultipleLooserContractPage), findsOneWidget);
    for (var i = 0; i < nbItems; i++) {
      await $(ElevatedButtonCustomColor)
          .containing($(Icons.add))
          .at(playerWithItems)
          .tap();
    }
  }
  await $(findValidateScoresButton($)).tap();
}

UncontrolledProviderScope _createPage(PatrolTester $,
    {TrumpsContractSettings? settings, MockPlayGameNotifier? mockPlayGame}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final mockStorage = MockMyStorage2();
  mockActiveContracts(mockStorage);
  mockPlayGame ??= MockPlayGameNotifier();
  mockGame(mockPlayGame);
  if (settings != null) {
    when(mockStorage.getSettings(ContractsInfo.trumps)).thenReturn(settings);
  }

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: const TrumpsContractPage(),
      routes: {
        Routes.chooseContract: (_) => const ChooseContract(),
        Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractPage(
              Routes.getArgument<ContractRouteArgument>(context),
            ),
        Routes.noSomethingScores: (context) => MultipleLooserContractPage(
              Routes.getArgument<ContractRouteArgument>(context),
            ),
      },
    ),
  );
}
