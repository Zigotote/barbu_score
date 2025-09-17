import 'package:barbu_score/commons/l10n/app_localizations.dart';
import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/my_locales.dart';
import 'package:barbu_score/commons/providers/locale_provider.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/commons/utils/snackbar.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/settings/contract_with_points_settings.dart';
import 'package:barbu_score/pages/settings/domino_contract_settings.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
import 'package:barbu_score/pages/settings/salad_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: Routes.home, builder: (_, _) => const MySettings()),
    GoRoute(
      path:
          "${Routes.contractWithPointsSettings}/:${MyGoRouterState.contractParameter}",
      builder: (_, state) => ContractWithPointsSettingsPage(state.contract),
    ),
    GoRoute(
      path: Routes.dominoSettings,
      builder: (_, _) => const DominoContractSettingsPage(),
    ),
    GoRoute(
      path: Routes.saladSettings,
      builder: (_, _) => const SaladContractSettingsPage(),
    ),
  ],
);

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because app theme switch is considered not accessible, but screen reader is correct
  });
  patrolWidgetTest("should change language", ($) async {
    $.tester.platformDispatcher.localeTestValue = MyLocales.fr.locale;
    final mockStorage = MockMyStorage();
    mockActiveContracts(mockStorage);
    final container = ProviderContainer(
      overrides: [
        logProvider.overrideWithValue(MockMyLog()),
        storageProvider.overrideWithValue(mockStorage),
      ],
    );

    await $.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp.router(
              supportedLocales: [MyLocales.fr.locale],
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: ref.watch(localeProvider),
              routerConfig: _router,
            );
          },
        ),
      ),
    );

    expect(
      ($.tester.firstWidget($(Key(MyLocales.fr.name))) as Opacity).opacity,
      1,
    );
    expect(
      ($.tester.firstWidget($(Key(MyLocales.en.name))) as Opacity).opacity,
      0.8,
    );

    await $(IconButton).at(1).tap();

    expect(
      ($.tester.firstWidget($(Key(MyLocales.fr.name))) as Opacity).opacity,
      0.8,
    );
    expect(
      ($.tester.firstWidget($(Key(MyLocales.en.name))) as Opacity).opacity,
      1,
    );
    final newLocale = MyLocales.en.locale;
    verify(mockStorage.saveLocale(newLocale));
    expect(container.read(localeProvider), newLocale);
  });
  for (var activeContracts in [
    ContractsInfo.values,
    [ContractsInfo.barbu],
    [ContractsInfo.barbu, ContractsInfo.salad, ContractsInfo.domino],
  ]) {
    patrolWidgetTest(
      "should display ${activeContracts.length} active contracts from storage",
      ($) async {
        await $.pumpWidget(_createPage(activeContracts: activeContracts));

        expect($("ON"), findsNWidgets(activeContracts.length));
        expect(
          $("OFF"),
          findsNWidgets(ContractsInfo.values.length - activeContracts.length),
        );
      },
    );
  }
  for (var modifiedContract in ContractsInfo.values) {
    for (var isModified in [true, false]) {
      patrolWidgetTest(
        "should ${isModified ? "reload" : "keep"} $modifiedContract activation on settings ${isModified ? "" : "not "}changed",
        ($) async {
          final mockStorage = MockMyStorage();
          await $.pumpWidget(_createPage(mockStorage: mockStorage));

          // Go to contract settings page
          await $.scrollUntilVisible(finder: $(Key(modifiedContract.name)));
          await $(
            Key(modifiedContract.name),
          ).tap(settlePolicy: SettlePolicy.trySettle);

          // Deactivate contract
          expect(($.tester.firstWidget($(Switch)) as Switch).value, true);
          if (isModified) {
            final modifiedContractSettings = modifiedContract.defaultSettings
                .copyWith(isActive: false);
            when(
              mockStorage.getSettings(modifiedContract),
            ).thenReturn(modifiedContractSettings);

            await $(MySwitch).tap();
            expect(($.tester.firstWidget($(Switch)) as Switch).value, false);
          }

          // Go back to global settings page
          await $(Icons.arrow_back).tap(settlePolicy: SettlePolicy.noSettle);
          await $.pump();

          if (isModified) {
            expect($("Modifications sauvegardées"), findsOneWidget);
            expect(
              $(Key(modifiedContract.name)).containing($("OFF")),
              findsOneWidget,
            );
            expect($("ON"), findsNWidgets(ContractsInfo.values.length - 1));
            verify(mockStorage.saveSettings(modifiedContract, any));
            verifyNever(mockStorage.deleteGame());
          } else {
            expect($("Modifications sauvegardées"), findsNothing);
            expect($("ON"), findsNWidgets(ContractsInfo.values.length));
            verifyNever(mockStorage.saveSettings(modifiedContract, any));
            verifyNever(mockStorage.deleteGame());
          }
        },
      );
    }
    for (var isGameFinished in [true, false]) {
      patrolWidgetTest(
        "should${isGameFinished ? " delete game and" : ""} save settings on $modifiedContract activation changed",
        ($) async {
          final mockStorage = MockMyStorage();
          when(
            mockStorage.getStoredGame(),
          ).thenReturn(Game(players: [])..isFinished = isGameFinished);
          await $.pumpWidget(_createPage(mockStorage: mockStorage));

          // Go to contract settings page
          await $.scrollUntilVisible(finder: $(Key(modifiedContract.name)));
          await $(
            Key(modifiedContract.name),
          ).tap(settlePolicy: SettlePolicy.trySettle);

          // Deactivate contract
          final modifiedContractSettings = modifiedContract.defaultSettings
              .copyWith(isActive: false);
          when(
            mockStorage.getSettings(modifiedContract),
          ).thenReturn(modifiedContractSettings);
          await $(MySwitch).tap();
          expect(($.tester.firstWidget($(Switch)) as Switch).value, false);

          // Go back to global settings page
          await $(Icons.arrow_back).tap(settlePolicy: SettlePolicy.noSettle);
          await $.pump();

          expect($("Modifications sauvegardées"), findsOneWidget);
          expect(
            $(Key(modifiedContract.name)).containing($("OFF")),
            findsOneWidget,
          );
          expect($("ON"), findsNWidgets(ContractsInfo.values.length - 1));
          verify(mockStorage.saveSettings(modifiedContract, any));
          if (isGameFinished) {
            verify(mockStorage.deleteGame());
          } else {
            verifyNever(mockStorage.deleteGame());
          }
        },
      );
    }
  }

  // The state of the singleton is shared during tests so the snackbar cannot be opened multiple times
  tearDown(() => SnackBarUtils.instance.isSnackBarOpen = false);
}

Widget _createPage({
  MockMyStorage? mockStorage,
  List<ContractsInfo> activeContracts = ContractsInfo.values,
}) {
  mockStorage ??= MockMyStorage();
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings.copyWith(
      isActive: activeContracts.contains(contract),
    );
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  final container = ProviderContainer(
    overrides: [
      logProvider.overrideWithValue(MockMyLog()),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(routerConfig: _router),
  );
}
