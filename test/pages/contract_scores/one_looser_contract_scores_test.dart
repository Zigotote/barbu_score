import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/models/contract_route_argument.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../fake/play_game.dart';
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

    expect($(ElevatedButton), findsNWidgets(nbPlayersByDefault + 1));
    final validateButton =
        ($.tester.firstWidget(_findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNull);
  });
  patrolWidgetTest(
      "should validate scores if one player is selected and go to next player turn",
      ($) async {
    await $.pumpWidget(_createPage());

    await $(ElevatedButton).at(0).tap();
    await _findValidateScoresButton($).tap();

    // TODO Océane to fix
    expect($(ChooseContract), findsOneWidget);
  });
  //patrolWidgetTest("should change selected player and validate scores", ($) async {});
}

PatrolFinder _findValidateScoresButton(PatrolTester $) {
  return $(ElevatedButton).containing("Valider les scores");
}

Widget _createPage() {
  final mockStorage = MockMyStorage2();
  mockActiveContracts(mockStorage, ContractsInfo.values);

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => FakePlayGame()),
      storageProvider.overrideWithValue(mockStorage)
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: OneLooserContractScoresPage(
        ContractRouteArgument(contractInfo: ContractsInfo.barbu),
      ),
      routes: {Routes.chooseContract: (_) => const ChooseContract()},
    ),
  );
}
