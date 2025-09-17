import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

import 'commons/l10n/app_localizations.dart';
import 'commons/models/contract_models.dart';
import 'commons/providers/locale_provider.dart';
import 'commons/providers/storage.dart';
import 'commons/utils/router_extension.dart';
import 'firebase_options.dart';
import 'pages/choose_contract.dart';
import 'pages/contract_scores/domino_contract.dart';
import 'pages/contract_scores/multiple_looser_contract.dart';
import 'pages/contract_scores/one_looser_contract.dart';
import 'pages/contract_scores/salad_contract.dart';
import 'pages/create_game/create_game.dart';
import 'pages/finish_game/finish_game.dart';
import 'pages/my_home.dart';
import 'pages/my_scores.dart';
import 'pages/prepare_game/prepare_game.dart';
import 'pages/rules/models/rules_page_name.dart';
import 'pages/rules/my_rules.dart';
import 'pages/scores_by_player.dart';
import 'pages/settings/contract_with_points_settings.dart';
import 'pages/settings/domino_contract_settings.dart';
import 'pages/settings/my_settings.dart';
import 'pages/settings/salad_contract_settings.dart';
import 'theme/my_themes.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kDebugMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await RiveNative.init();
  await MyStorage.init();

  runApp(
    ProviderScope(
      child: MyApp(
        // Router is initialized before any ref.watch call to prevent the app from an entire reload when a provider updates
        // cf https://github.com/flutter/flutter/issues/136579
        router: GoRouter(
          initialLocation: Routes.home,
          routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const MyHome()),
            GoRoute(path: Routes.home, builder: (_, __) => const MyHome()),
            GoRoute(
                path: Routes.rules,
                name: Routes.rules,
                builder: (_, state) {
                  final rulesPageName =
                      state.uri.queryParameters[MyGoRouterState.rulesPage];
                  return MyRules(
                    startingPage: rulesPageName != null
                        ? RulesPageName.fromName(rulesPageName)
                        : null,
                  );
                }),
            GoRoute(
              path: Routes.settings,
              builder: (_, __) => const MySettings(),
            ),
            GoRoute(
              path:
                  "${Routes.contractWithPointsSettings}/:${MyGoRouterState.contractParameter}",
              builder: (_, state) =>
                  ContractWithPointsSettingsPage(state.contract),
            ),
            GoRoute(
                path: Routes.dominoSettings,
                builder: (_, __) => const DominoContractSettingsPage()),
            GoRoute(
              path: Routes.saladSettings,
              builder: (_, __) => const SaladContractSettingsPage(),
            ),
            GoRoute(path: Routes.createGame, builder: (_, __) => CreateGame()),
            GoRoute(
                path: Routes.prepareGame,
                builder: (_, __) => const PrepareGame()),
            GoRoute(
                path: Routes.chooseContract,
                builder: (_, __) => const ChooseContract()),
            GoRoute(
              path:
                  "${Routes.oneLooserScores}/:${MyGoRouterState.contractParameter}",
              builder: (_, state) => OneLooserContractPage(
                state.contract,
                contractModel: state.extra as ContractWithPointsModel?,
              ),
            ),
            GoRoute(
              path: Routes.dominoScores,
              builder: (_, __) => const DominoContractPage(),
            ),
            GoRoute(
              path:
                  "${Routes.noSomethingScores}/:${MyGoRouterState.contractParameter}",
              builder: (_, state) => MultipleLooserContractPage(
                state.contract,
                contractModel: state.extra as ContractWithPointsModel?,
              ),
            ),
            GoRoute(
              path: Routes.saladScores,
              builder: (_, __) => const SaladContractPage(),
            ),
            GoRoute(path: Routes.scores, builder: (_, __) => const MyScores()),
            GoRoute(
              path: Routes.scoresByPlayer,
              name: Routes.scoresByPlayer,
              builder: (_, state) => ScoresByPlayer(
                state.uri.queryParameters[MyGoRouterState.playerParameter]!,
              ),
            ),
            GoRoute(
              path: Routes.finishGame,
              builder: (_, __) => const FinishGame(),
            ),
          ],
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: _getThemeMode(ref),
      routerConfig: router,
      builder: (context, child) => AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
        child: child!,
      ),
    );
  }

  /// Returns the themeMode depending on data provider data
  ThemeMode _getThemeMode(WidgetRef ref) {
    bool? savedIsDarkTheme = ref.watch(isDarkThemeProvider);
    switch (savedIsDarkTheme) {
      case true:
        return ThemeMode.dark;
      case false:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}

/// Names of the routes for the app
class Routes {
  static const home = "/";
  static const rules = "/rules";
  static const settings = "/settings";
  static const contractWithPointsSettings = "/settings/contracts_with_points";
  static const dominoSettings = "/settings/domino";
  static const saladSettings = "/settings/salad";
  static const createGame = "/create_game";
  static const prepareGame = "/prepare_game";
  static const chooseContract = "/choose_contract";
  static const oneLooserScores = "/one_looser_contract_scores";
  static const dominoScores = "/domino_scores";
  static const noSomethingScores = "/individual_scores";
  static const saladScores = "/salad_scores";
  static const scores = "/scores";
  static const scoresByPlayer = "/scores/player";
  static const finishGame = "/end_game";
}
