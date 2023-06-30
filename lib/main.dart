import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../pages/finish_party.dart';
import 'commons/models/player.dart';
import 'commons/utils/storage.dart';
import 'pages/choose_contract.dart';
import 'pages/contract_scores/domino_scores.dart';
import 'pages/contract_scores/individual_scores_contract.dart';
import 'pages/contract_scores/models/contract_route_argument.dart';
import 'pages/contract_scores/one_looser_contract_scores.dart';
import 'pages/contract_scores/trumps_scores.dart';
import 'pages/create_game/create_game.dart';
import 'pages/my_home.dart';
import 'pages/my_rules.dart';
import 'pages/my_scores.dart';
import 'pages/my_settings.dart';
import 'pages/prepare_game.dart';
import 'pages/scores_by_player.dart';
import 'theme/my_themes.dart';
import 'theme/theme_provider.dart';

void main() {
  Get.put(MyStorage());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Barbu Score',
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode:
          ref.watch(appThemeProvider).state ? ThemeMode.dark : ThemeMode.light,
      routerConfig: GoRouter(routes: [
        GoRoute(
          path: Routes.home,
          builder: (_, __) => const MyHome(),
        ),
        GoRoute(
          path: Routes.rules,
          builder: (_, __) => const MyRules(),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (_, __) => const MySettings(),
        ),
        GoRoute(
          path: Routes.createGame,
          builder: (_, __) => CreateGame(),
          //binding: CreatePlayersBinding(),
        ),
        GoRoute(
          path: Routes.prepareGame,
          builder: (_, __) => PrepareGame(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.chooseContract,
          builder: (_, __) => const ChooseContract(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.barbuOrNoLastTrickScores,
          builder: (_, state) =>
              OneLooserContractScores(state.extra as ContractRouteArgument),
          //binding: SelectPlayerBinding(),
        ),
        GoRoute(
          path: Routes.dominoScores,
          builder: (_, __) => const DominoScores(),
          //binding: OrderPlayerBinding(),
        ),
        GoRoute(
          path: Routes.noSomethingScores,
          builder: (_, state) =>
              IndividualScoresContract(state.extra as ContractRouteArgument),
          //binding: IndividualScoresBinding(),
        ),
        GoRoute(
          path: Routes.trumpsScores,
          builder: (_, __) => const TrumpsScores(),
          //binding: TrumpsScoresBinding(),
        ),
        GoRoute(
          path: Routes.scores,
          builder: (_, __) => const MyScores(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.scoresByPlayer,
          builder: (_, state) => ScoresByPlayer(state.extra as Player),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.finishGame,
          builder: (_, __) => const FinishParty(),
          //binding: PartyBinding(),
        ),
      ]),
    );
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
