import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/domino_scores.dart';
import 'package:barbu_score/pages/contract_scores/models/contract_route_argument.dart';
import 'package:barbu_score/pages/contract_scores/multiple_scores_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract_scores.dart';
import 'package:barbu_score/pages/contract_scores/trumps_scores.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../fake/game.dart';
import '../fake/play_game.dart';
import '../utils.dart';
import 'my_home_test.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Tour de ${defaultPlayerNames[0]}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var contracts in [
    (
      active: ContractsInfo.values,
      played: [ContractsInfo.barbu, ContractsInfo.trumps, ContractsInfo.domino]
    ),
    (active: [ContractsInfo.barbu], played: <ContractsInfo>[]),
    (
      active: [ContractsInfo.barbu, ContractsInfo.trumps, ContractsInfo.domino],
      played: [ContractsInfo.barbu]
    )
  ]) {
    final activeContracts = contracts.active;
    final playedContracts = contracts.played;
    patrolWidgetTest("should display enabled contracts $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage($, activeContracts: activeContracts));

      expect($(ElevatedButton), findsNWidgets(activeContracts.length + 1));
      for (var contract in ContractsInfo.values) {
        final isActiveContract = activeContracts.contains(contract);
        expect(
          $(contract.displayName),
          isActiveContract ? findsOneWidget : findsNothing,
        );
        if (isActiveContract) {
          expect(
            $(Key(contract.name)).which(
                (widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget,
          );
        }
      }
    });
    patrolWidgetTest("should display disabled contracts $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage($,
          activeContracts: activeContracts, playedContracts: playedContracts));

      expect($(ElevatedButton), findsNWidgets(activeContracts.length + 1));
      for (var contract in activeContracts) {
        expect($(contract.displayName), findsOneWidget);
        expect(
          $(Key(contract.name)).which((widget) {
            final onPressed = (widget as ElevatedButton).onPressed;
            return playedContracts.contains(contract)
                ? onPressed == null
                : onPressed != null;
          }),
          findsOneWidget,
        );
      }
    });
  }
  group("Navigation", () {
    for (var contract in ContractsInfo.values) {
      patrolWidgetTest(
          "should go to $contract score pages and keep contract available",
          ($) async {
        await $.pumpWidget(_createPage($));

        await $(Key(contract.name)).tap();
        expect($("Valider les scores"), findsOneWidget);

        await $(IconButton).tap();
        expect($(ChooseContract), findsOneWidget);
        expect(
            $(Key(contract.name)).which(
                (widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget);
      });
    }
    patrolWidgetTest("should go to scores page", ($) async {
      await $.pumpWidget(_createPage($));

      await $("Scores").tap();
      expect($(MyScores), findsOneWidget);
    });
  });
}

Widget _createPage($,
    {List<ContractsInfo> activeContracts = ContractsInfo.values,
    List<ContractsInfo> playedContracts = const []}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  final mockStorage = MockMyStorage2();
  mockActiveContracts(mockStorage, activeContracts);

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith(
        (_) => FakePlayGame(
          FakeGame(
            players: List.generate(
              nbPlayersByDefault,
              (index) => Player(
                name: defaultPlayerNames[index],
                color: PlayerColors.values[index],
                image: playerImages[index],
                contracts: [] /*TODO Océane to fix playedContracts
                    .map((contract) => contract.contract)
                    .toList() */
                ,
              ),
            ),
          ),
        ),
      ),
      storageProvider.overrideWithValue(mockStorage),
      /*TODO Océane to fix trumpsProvider
          .overrideWith((ref) => FakeTrumpsProvider(ContractsInfo.values))*/
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: const ChooseContract(), routes: {
      Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractScoresPage(
            ContractRouteArgument(contractInfo: ContractsInfo.barbu),
          ),
      Routes.noSomethingScores: (context) => MultipleLooserContractPage(
            ContractRouteArgument(contractInfo: ContractsInfo.noQueens),
          ),
      Routes.dominoScores: (_) => const DominoScores(),
      Routes.trumpsScores: (_) => const TrumpsScores(),
      Routes.scores: (_) => const MyScores()
    }),
  );
}
