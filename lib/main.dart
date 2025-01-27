import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'commons/models/contract_info.dart';
import 'commons/models/player.dart';
import 'commons/providers/locale_provider.dart';
import 'commons/providers/storage.dart';
import 'firebase_options.dart';
import 'pages/choose_contract.dart';
import 'pages/contract_scores/domino_contract.dart';
import 'pages/contract_scores/models/contract_route_argument.dart';
import 'pages/contract_scores/multiple_looser_contract.dart';
import 'pages/contract_scores/one_looser_contract.dart';
import 'pages/contract_scores/trumps_contract.dart';
import 'pages/create_game/create_game.dart';
import 'pages/finish_game/finish_game.dart';
import 'pages/my_home.dart';
import 'pages/my_scores.dart';
import 'pages/prepare_game.dart';
import 'pages/rules/my_rules.dart';
import 'pages/scores_by_player.dart';
import 'pages/settings/domino_contract_settings.dart';
import 'pages/settings/multiple_looser_contract_settings.dart';
import 'pages/settings/my_settings.dart';
import 'pages/settings/one_looser_contract_settings.dart';
import 'pages/settings/trumps_contract_settings.dart';
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

  await MyStorage.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = _getThemeMode(ref);
    return MaterialApp(
      title: 'Barbu Score',
      // TODO Océane internationaaliser le nom de l'app
      // TODO Océane passer les drapeaux à 80% d'opacité quand ils sont desséléctionnés, 100% quand c'est sélectionné
      // TODO Océane réfélchir où mettre le choiix de la laangue dans la page de paramètres
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: themeMode,
      routes: {
        Routes.home: (_) => const MyHome(),
        Routes.rules: (_) => const MyRules(),
        Routes.settings: (_) => const MySettings(),
        Routes.barbuOrNoLastTrickSettings: (context) =>
            OneLooserContractSettingsPage(
                Routes.getArgument<ContractsInfo>(context)),
        Routes.noSomethingScoresSettings: (context) =>
            MultipleLooserContractSettingsPage(
                Routes.getArgument<ContractsInfo>(context)),
        Routes.dominoSettings: (_) => const DominoContractSettingsPage(),
        Routes.trumpsSettings: (_) => const TrumpsContractSettingsPage(),
        Routes.createGame: (_) => CreateGame(),
        Routes.prepareGame: (_) => const PrepareGame(),
        Routes.chooseContract: (_) => const ChooseContract(),
        Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractPage(
            Routes.getArgument<ContractRouteArgument>(context)),
        Routes.dominoScores: (_) => const DominoContractPage(),
        Routes.noSomethingScores: (context) => MultipleLooserContractPage(
            Routes.getArgument<ContractRouteArgument>(context)),
        Routes.trumpsScores: (_) => const TrumpsContractPage(),
        Routes.scores: (_) => const MyScores(),
        Routes.scoresByPlayer: (context) =>
            ScoresByPlayer(Routes.getArgument<Player>(context)),
        Routes.finishGame: (_) => const FinishGame(),
      },
      initialRoute: Routes.home,
      // Another ProviderScope so that whole app is not reloaded after theme mode change
      builder: (context, child) => ProviderScope(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
            systemNavigationBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
          child: child!,
        ),
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
  static const barbuOrNoLastTrickSettings =
      "/settings/one_looser_contract_scores";
  static const noSomethingScoresSettings = "/settings/individual_scores";
  static const dominoSettings = "/settings/domino";
  static const trumpsSettings = "/settings/trumps";
  static const createGame = "/create_game";
  static const prepareGame = "/prepare_game";
  static const chooseContract = "/choose_contract";
  static const barbuOrNoLastTrickScores = "/one_looser_contract_scores";
  static const dominoScores = "/domino_scores";
  static const noSomethingScores = "/individual_scores";
  static const trumpsScores = "/trumps_scores";
  static const scores = "/scores";
  static const scoresByPlayer = "/scores/player";
  static const finishGame = "/end_game";

  @visibleForTesting
  static T getArgument<T>(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments as T;
}
