import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/rules/contracts_rules.dart';
import 'package:barbu_score/pages/rules/widgets/settings_card.dart';
import 'package:barbu_score/pages/settings/domino_contract_settings.dart';
import 'package:barbu_score/pages/settings/multiple_looser_contract_settings.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
import 'package:barbu_score/pages/settings/one_looser_contract_settings.dart';
import 'package:barbu_score/pages/settings/salad_contract_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';

void main() {
  for (var activeContracts in [
    ContractsInfo.values,
    [ContractsInfo.barbu],
    [ContractsInfo.barbu, ContractsInfo.salad, ContractsInfo.domino]
  ]) {
    patrolWidgetTest(
        "should display contract rules with active $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage(activeContracts: activeContracts));
      expect($("Contrats"), findsOneWidget);

      for (var contract in ContractsInfo.values) {
        expect($(Key(contract.name)), findsOneWidget);
        expect(
          $(Key(contract.name)).containing("Désactivé pour vos parties."),
          activeContracts.contains(contract) ? findsNothing : findsOneWidget,
        );
      }
    });
    patrolWidgetTest(
        "should display contract rules with only active contracts $activeContracts",
        ($) async {
      await $.pumpWidget(
          _createPage(activeContracts: activeContracts, isInGame: true));
      expect($("Contrats"), findsOneWidget);

      for (var contract in ContractsInfo.values) {
        expect(
          $(Key(contract.name)),
          activeContracts.contains(contract) ? findsOneWidget : findsNothing,
        );
      }
    });
  }
  patrolWidgetTest("should go to settings page", ($) async {
    await $.pumpWidget(_createPage());

    await $.scrollUntilVisible(finder: $(SettingsCard));
    await $(OutlinedButton).tap();

    expect($(MySettings), findsOneWidget);
  });
  for (var contract in ContractsInfo.values) {
    patrolWidgetTest("should go to $contract settings page", ($) async {
      await $.pumpWidget(_createPage());

      final contractSettingsButton = find.descendant(
        of: $(Key(contract.name)),
        matching: $(IconButton),
      );
      await $.scrollUntilVisible(finder: contractSettingsButton);
      await $.tap(contractSettingsButton);

      expect($("Paramètres"), findsOneWidget);
    });
  }
}

Widget _createPage(
    {List<ContractsInfo>? activeContracts, bool isInGame = false}) {
  final mockStorage = MockMyStorage();
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings
        .copyWith(isActive: activeContracts?.contains(contract) ?? false);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (_, __) => ContractsRules(0, isInGame: isInGame),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (_, __) => const MySettings(),
          ),
          GoRoute(
            path:
                "${Routes.barbuOrNoLastTrickSettings}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) =>
                OneLooserContractSettingsPage(state.contract),
          ),
          GoRoute(
            path:
                "${Routes.noSomethingScoresSettings}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) =>
                MultipleLooserContractSettingsPage(state.contract),
          ),
          GoRoute(
              path: Routes.dominoSettings,
              builder: (_, __) => const DominoContractSettingsPage()),
          GoRoute(
            path: Routes.saladSettings,
            builder: (_, __) => const SaladContractSettingsPage(),
          ),
        ],
      ),
    ),
  );
}
