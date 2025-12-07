import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/notifiers/salad_provider.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/salad_contract.dart';
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

    expect($("Quel est le score de chaque contrat ?"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should open and close salad rules", ($) async {
    await $.pumpWidget(_createPage($));

    await $.tap($(Icons.question_mark_outlined));
    expect($(DraggableScrollableSheet), findsOneWidget);
    expect($("Règles Salade"), findsOneWidget);

    await $.tap($(Icons.close));
    expect($(DraggableScrollableSheet), findsNothing);
  });

  for (var activeContracts in [
    SaladContractSettings.availableContracts,
    [ContractsInfo.barbu],
    [ContractsInfo.noQueens, ContractsInfo.barbu],
  ]) {
    patrolWidgetTest(
      "should create page with unfilled contracts $activeContracts",
      ($) async {
        await $.pumpWidget(
          _createPage(
            $,
            settings: SaladContractSettings(
              contracts: {
                for (var contract in SaladContractSettings.availableContracts)
                  contract.name: activeContracts.contains(contract),
              },
            ),
          ),
        );

        for (var contract in SaladContractSettings.availableContracts) {
          expect(
            $(Key(contract.name)),
            activeContracts.contains(contract) ? findsOneWidget : findsNothing,
          );
        }
        expect($(Icons.task_alt_outlined), findsNothing);
        final validateButton =
            ($.tester.firstWidget(findValidateScoresButton($))
                as ElevatedButton);
        expect(validateButton.onPressed, isNull);
      },
    );
  }
  for (var contractToFill in SaladContractSettings.availableContracts) {
    patrolWidgetTest("should fill $contractToFill sub contract", ($) async {
      final mockPlayGame = mockPlayGameNotifier();
      final page = _createPage($, mockPlayGame: mockPlayGame);
      await $.pumpWidget(page);

      expect(page.container.read(saladProvider).model.subContracts, isEmpty);
      final subContractModel = await _fillSubContract(
        $,
        mockPlayGame,
        contractToFill,
        page.container
                .read(contractsManagerProvider)
                .getContractManager(contractToFill)
                .model
            as ContractWithPointsModel,
      );

      // Redirect to salad contract page
      expect($(SaladContractPage), findsOneWidget);
      expect(
        $(ElevatedButtonWithIndicator).containing($(Icon)),
        findsOneWidget,
      );
      expect(
        $(
          ElevatedButtonWithIndicator,
        ).which((Widget widget) => widget.key == Key(contractToFill.name)),
        findsOneWidget,
      );
      final validateButton =
          ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
      expect(validateButton.onPressed, isNull);

      // Verifies the contract has been saved
      final savedSaladContracts = page.container
          .read(saladProvider)
          .model
          .subContracts;
      expect(savedSaladContracts.length, 1);
      expect(savedSaladContracts.first, subContractModel);
    });
  }
  patrolWidgetTest("should modify one looser sub contract", ($) async {
    const contract = ContractsInfo.barbu;
    final mockPlayGame = mockPlayGameNotifier();
    final page = _createPage($, mockPlayGame: mockPlayGame);
    final playerSelectedAfterModify = mockPlayGame.players.length - 1;
    final expectedSubContract = ContractWithPointsModel(
      contract: contract,
      itemsByPlayer: {
        for (var (index, player) in mockPlayGame.players.indexed)
          player.name: index == playerSelectedAfterModify ? 1 : 0,
      },
    );

    await $.pumpWidget(page);

    expect(page.container.read(saladProvider).model.subContracts, isEmpty);
    await _fillSubContract(
      $,
      mockPlayGame,
      contract,
      page.container
              .read(contractsManagerProvider)
              .getContractManager(contract)
              .model
          as ContractWithPointsModel,
    );

    // Redirect to salad contract page
    expect($(SaladContractPage), findsOneWidget);

    // Modify contract
    await $(Key(contract.name)).tap();
    await $(ElevatedButtonCustomColor).at(playerSelectedAfterModify).tap();
    await findValidateScoresButton($).tap();

    // Redirect to salad contract page
    expect($(ElevatedButtonWithIndicator).containing($(Icon)), findsOneWidget);
    expect(
      $(
        ElevatedButtonWithIndicator,
      ).which((Widget widget) => widget.key == Key(contract.name)),
      findsOneWidget,
    );
    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNull);

    // Verifies the contract has been saved
    final savedSaladContracts = page.container
        .read(saladProvider)
        .model
        .subContracts;
    expect(savedSaladContracts.length, 1);
    expect(savedSaladContracts.first, expectedSubContract);
  });
  patrolWidgetTest("should modify multiple loosers sub contract", ($) async {
    const contract = ContractsInfo.noQueens;
    final mockPlayGame = mockPlayGameNotifier();
    final page = _createPage($, mockPlayGame: mockPlayGame);
    final playerSelectedAfterModify = mockPlayGame.players.length - 1;
    final expectedSubContract = ContractWithPointsModel(
      contract: contract,
      nbItems: 4,
      itemsByPlayer: {
        for (var (index, player) in mockPlayGame.players.indexed)
          player.name: index == playerSelectedAfterModify ? 4 : 0,
      },
    );

    await $.pumpWidget(page);

    expect(page.container.read(saladProvider).model.subContracts, isEmpty);
    await _fillSubContract(
      $,
      mockPlayGame,
      contract,
      page.container
              .read(contractsManagerProvider)
              .getContractManager(contract)
              .model
          as ContractWithPointsModel,
    );

    // Redirect to salad contract page
    expect($(SaladContractPage), findsOneWidget);

    // Modify contract
    await $(Key(contract.name)).tap();
    for (var i = 0; i < expectedSubContract.nbItems; i++) {
      await $(IconButton).containing($(Icons.remove)).at(0).tap();
      await $(
        IconButton,
      ).containing($(Icons.add)).at(playerSelectedAfterModify).tap();
    }
    await findValidateScoresButton($).tap();

    // Redirect to salad contract page
    expect($(ElevatedButtonWithIndicator).containing($(Icon)), findsOneWidget);
    expect(
      $(
        ElevatedButtonWithIndicator,
      ).which((Widget widget) => widget.key == Key(contract.name)),
      findsOneWidget,
    );
    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNull);

    // Verifies the contract has been saved
    final savedSaladContracts = page.container
        .read(saladProvider)
        .model
        .subContracts;
    expect(savedSaladContracts.length, 1);
    expect(savedSaladContracts.first, expectedSubContract);
  });
  patrolWidgetTest("should validate when all contracts are filled", ($) async {
    final mockPlayGame = mockPlayGameNotifier();
    final page = _createPage($, mockPlayGame: mockPlayGame);
    final contractModel = SaladContractModel();
    await $.pumpWidget(page);

    for (var contract in SaladContractSettings.availableContracts) {
      final subContractModel = await _fillSubContract(
        $,
        mockPlayGame,
        contract,
        page.container
                .read(contractsManagerProvider)
                .getContractManager(contract)
                .model
            as ContractWithPointsModel,
      );
      contractModel.addSubContract(subContractModel);
    }

    // Redirect to salad contract page
    expect($(SaladContractPage), findsOneWidget);
    expect(
      $(ElevatedButtonWithIndicator),
      findsNWidgets(SaladContractSettings.availableContracts.length),
    );
    await findValidateScoresButton($).tap();

    expect($(ChooseContract), findsOneWidget);
    verify(mockPlayGame.finishContract(contractModel));
    verify(mockPlayGame.nextPlayer());
  });
}

/// Fills the subContract. Modifies the [contractModel] accordingly and returns it
Future<ContractWithPointsModel> _fillSubContract(
  PatrolTester $,
  MockPlayGameNotifier game,
  ContractsInfo contract,
  ContractWithPointsModel contractModel,
) async {
  const playerWithItems = 0;
  // Navigate to contract
  await $(Key(contract.name)).tap();

  // Fill contract
  if (contractModel.nbItems == 1) {
    expect($(OneLooserContractPage), findsOneWidget);
    await $(ElevatedButtonCustomColor).at(playerWithItems).tap();
  } else {
    expect($(MultipleLooserContractPage), findsOneWidget);
    for (var i = 0; i < contractModel.nbItems; i++) {
      await $(IconButton).containing($(Icons.add)).at(playerWithItems).tap();
    }
  }
  await $(findValidateScoresButton($)).tap();
  return contractModel.copyWith(
    itemsByPlayer: {
      for (var (index, player) in game.players.indexed)
        player.name: index == playerWithItems ? contractModel.nbItems : 0,
    },
  );
}

UncontrolledProviderScope _createPage(
  PatrolTester $, {
  SaladContractSettings? settings,
  MockPlayGameNotifier? mockPlayGame,
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);
  mockPlayGame ??= mockPlayGameNotifier();
  if (settings != null) {
    when(mockStorage.getSettings(ContractsInfo.salad)).thenReturn(settings);
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
            builder: (_, _) => const SaladContractPage(),
          ),
          GoRoute(
            path: Routes.chooseContract,
            builder: (_, _) => const ChooseContract(),
          ),
          GoRoute(
            path:
                "${Routes.oneLooserScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => OneLooserContractPage(
              state.contract,
              contractModel: state.extra as ContractWithPointsModel?,
            ),
          ),
          GoRoute(
            path:
                "${Routes.noSomethingScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => MultipleLooserContractPage(
              state.contract,
              contractModel: state.extra as ContractWithPointsModel?,
            ),
          ),
        ],
      ),
    ),
  );
}
