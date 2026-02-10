import 'package:barbu_score/commons/l10n/app_localizations.dart';
import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/models/my_locales.dart';
import 'package:barbu_score/commons/providers/locale_provider.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/settings/my_about.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
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
    when(mockStorage.getGameSettings()).thenReturn(GameSettings());

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
            return MaterialApp(
              supportedLocales: [MyLocales.fr.locale],
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: ref.watch(localeProvider),
              builder: (_, _) => MySettings(),
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

  patrolWidgetTest("should open about page", ($) async {
    final aboutText = "A propos";
    await $.pumpWidget(_createPage());

    await $.scrollUntilVisible(finder: $(aboutText));
    await $(aboutText).tap();

    expect($(MyAbout), findsOneWidget);
  });
}

Widget _createPage({
  MockMyStorage? mockStorage,
  List<ContractsInfo> activeContracts = ContractsInfo.values,
}) {
  mockStorage ??= MockMyStorage();
  when(mockStorage.getGameSettings()).thenReturn(GameSettings());
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
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const MySettings()),
          GoRoute(path: Routes.about, builder: (_, _) => const MyAbout()),
        ],
      ),
    ),
  );
}
