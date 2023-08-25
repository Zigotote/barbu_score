import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'pages/my_settings.dart';
import 'pages/prepare_game.dart';
import 'pages/scores_by_player.dart';
import 'theme/my_themes.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyStorage().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Barbu Score',
        theme: MyThemes.light,
        darkTheme: MyThemes.dark,
        routes: {
          Routes.home: (_) => const MyHome(),
          Routes.rules: (_) => const MyRules(),
          Routes.settings: (_) => const MySettings(),
          Routes.createGame: (_) => CreateGame(),
          Routes.prepareGame: (_) => PrepareGame(),
          Routes.chooseContract: (_) => const ChooseContract(),
          Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractScores(
              ModalRoute.of(context)?.settings.arguments
                  as ContractRouteArgument),
          Routes.dominoScores: (_) => const DominoScores(),
          Routes.noSomethingScores: (context) => IndividualScoresContract(
              ModalRoute.of(context)?.settings.arguments
                  as ContractRouteArgument),
          Routes.trumpsScores: (_) => const TrumpsScores(),
          Routes.scores: (_) => const MyScores(),
          Routes.scoresByPlayer: (context) => ScoresByPlayer(
              ModalRoute.of(context)?.settings.arguments as Player),
          Routes.finishGame: (_) => const FinishGame(),
        },
        initialRoute: Routes.home,
        builder: (context, child) => child!);
  }
}

/// Names of the routes for the app
class Routes {
  static const home = "/";
  static const rules = "/rules";
  static const settings = "/settings";
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
