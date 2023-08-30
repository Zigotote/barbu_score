import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/pages/settings/domino_contract_settings.dart';
import 'commons/models/contract_info.dart';
import 'commons/models/player.dart';
import 'commons/utils/storage.dart';
import 'pages/choose_contract.dart';
import 'pages/contract_scores/domino_scores.dart';
import 'pages/contract_scores/individual_scores_contract.dart';
import 'pages/contract_scores/models/contract_route_argument.dart';
import 'pages/contract_scores/one_looser_contract_scores.dart';
import 'pages/contract_scores/trumps_scores.dart';
import 'pages/create_game/create_game.dart';
import 'pages/finish_game/finish_game.dart';
import 'pages/my_home.dart';
import 'pages/my_rules.dart';
import 'pages/my_scores.dart';
import 'pages/prepare_game.dart';
import 'pages/scores_by_player.dart';
import 'pages/settings/individual_scores_contract_settings.dart';
import 'pages/settings/my_settings.dart';
import 'pages/settings/one_looser_contract_settings.dart';
import 'pages/settings/trumps_contract_settings.dart';
import 'theme/my_themes.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: themeMode,
      routes: {
        Routes.home: (_) => const MyHome(),
        Routes.rules: (_) => const MyRules(),
        Routes.settings: (_) => const MySettings(),
        Routes.barbuOrNoLastTrickSettings: (context) =>
            OneLooserContractSettingsPage(
                _getRouteArgument<ContractsInfo>(context)),
        Routes.noSomethingScoresSettings: (context) =>
            IndividualScoresContractSettingsPage(
                _getRouteArgument<ContractsInfo>(context)),
        Routes.dominoSettings: (_) => const DominoContractSettingsPage(),
        Routes.trumpsSettings: (_) => TrumpsContractSettingsPage(),
        Routes.createGame: (_) => CreateGame(),
        Routes.prepareGame: (_) => PrepareGame(),
        Routes.chooseContract: (_) => const ChooseContract(),
        Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractScores(
            _getRouteArgument<ContractRouteArgument>(context)),
        Routes.dominoScores: (_) => const DominoScores(),
        Routes.noSomethingScores: (context) => IndividualScoresContract(
            _getRouteArgument<ContractRouteArgument>(context)),
        Routes.trumpsScores: (_) => const TrumpsScores(),
        Routes.scores: (_) => const MyScores(),
        Routes.scoresByPlayer: (context) =>
            ScoresByPlayer(_getRouteArgument<Player>(context)),
        Routes.finishGame: (_) => const FinishGame(),
      },
      initialRoute: Routes.home,
      // Another ProviderScope so that whole app is not reloaded after theme mode change
      builder: (context, child) => ProviderScope(
        child: child!,
      ),
    );
  }

  T _getRouteArgument<T>(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments as T;

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
}
