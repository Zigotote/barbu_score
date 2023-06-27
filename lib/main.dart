import 'package:barbu_score/pages/create_game/create_game.dart';
import 'package:barbu_score/pages/prepare_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import './controller/contract.dart';
import './pages/choose_contract.dart';
import './pages/domino_scores.dart';
import './pages/individual_scores_contract.dart';
import './pages/my_home.dart';
import './pages/my_rules.dart';
import './pages/my_settings.dart';
import './pages/one_looser_contract_scores.dart';
import './pages/scores_by_player.dart';
import './pages/trump_scores.dart';
import './theme/my_themes.dart';
import './theme/theme_provider.dart';
import './utils/storage.dart';
import '../pages/finish_party.dart';
import '../pages/my_scores.dart';

void main() {
  Get.put(MyStorage());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
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
          path: Routes.HOME,
          builder: (_, __) => MyHome(),
        ),
        GoRoute(
          path: Routes.RULES,
          builder: (_, __) => MyRules(),
        ),
        GoRoute(
          path: Routes.SETTINGS,
          builder: (_, __) => MySettings(),
        ),
        GoRoute(
          path: Routes.CREATE_GAME,
          builder: (_, __) => CreateGame(),
          //binding: CreatePlayersBinding(),
        ),
        GoRoute(
          path: Routes.PREPARE_GAME,
          builder: (_, __) => PrepareGame(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.CHOOSE_CONTRACT,
          builder: (_, __) => ChooseContract(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.BARBU_OR_NOLASTTRICK_SCORES,
          builder: (_, __) => OneLooserContractScores(),
          //binding: SelectPlayerBinding(),
        ),
        GoRoute(
          path: Routes.DOMINO_SCORES,
          builder: (_, __) => DominoScores(),
          //binding: OrderPlayerBinding(),
        ),
        GoRoute(
          path: Routes.NO_SOMETHING_SCORES,
          builder: (_, __) => IndividualScoresContract(),
          //binding: IndividualScoresBinding(),
        ),
        GoRoute(
          path: Routes.TRUMPS_SCORES,
          builder: (_, __) => TrumpsScores(),
          //binding: TrumpsScoresBinding(),
        ),
        GoRoute(
          path: Routes.SCORES,
          builder: (_, __) => MyScores(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.SCORES_BY_PLAYER,
          builder: (_, __) => ScoresByPlayer(),
          //binding: PartyBinding(),
        ),
        GoRoute(
          path: Routes.FINISH_PARTY,
          builder: (_, __) => FinishParty(),
          //binding: PartyBinding(),
        ),
      ]),
    );
  }
}

/// Names of the routes for the app
class Routes {
  static const HOME = "/";
  static const RULES = "/rules";
  static const SETTINGS = "/settings";
  static const CREATE_GAME = "/create_game";
  static const PREPARE_GAME = "/prepare_game";
  static const CHOOSE_CONTRACT = "/choose_contract";
  static const BARBU_OR_NOLASTTRICK_SCORES = "/one_looser_contract_scores";
  static const DOMINO_SCORES = "/domino_scores";
  static const NO_SOMETHING_SCORES = "/individual_scores";
  static const TRUMPS_SCORES = "/trumps_scores";
  static const SCORES = "/scores";
  static const SCORES_BY_PLAYER = "/scores/player";
  static const FINISH_PARTY = "/end_party";

  /// Returns true if the contract of this route is part of a trumps contract
  static bool isPartOfTrumpsContract() {
    try {
      Get.find<TrumpsScoresController>();
      return true;
    } catch (_) {
      return false;
    }
  }
}
