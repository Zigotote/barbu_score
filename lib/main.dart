import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './bindings/contract.dart';
import './bindings/create_players.dart';
import './bindings/party.dart';
import './pages/choose_contract.dart';
import './pages/create_party.dart';
import './pages/domino_scores.dart';
import './pages/individual_scores_contract.dart';
import './pages/my_home.dart';
import './pages/one_looser_contract_scores.dart';
import './pages/scores_by_player.dart';
import './pages/trump_scores.dart';
import './theme/my_themes.dart';
import '../pages/my_scores.dart';
import './controller/contract.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Barbu Score',
      theme: MyThemes.light,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: Routes.HOME,
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () => MyHome(),
        ),
        GetPage(
          name: Routes.CREATE_PARTY,
          page: () => CreateParty(),
          binding: CreatePlayersBinding(),
        ),
        GetPage(
          name: Routes.CHOOSE_CONTRACT,
          page: () => ChooseContract(),
          binding: PartyBinding(),
        ),
        GetPage(
          name: Routes.BARBU_OR_NOLASTTRICK_SCORES,
          page: () => OneLooserContractScores(),
          binding: SelectPlayerBinding(),
        ),
        GetPage(
          name: Routes.DOMINO_SCORES,
          page: () => DominoScores(),
          binding: OrderPlayerBinding(),
        ),
        GetPage(
          name: Routes.NO_SOMETHING_SCORES,
          page: () => IndividualScoresContract(),
          binding: IndividualScoresBinding(),
        ),
        GetPage(
          name: Routes.TRUMPS_SCORES,
          page: () => TrumpsScores(),
          binding: TrumpsScoresBinding(),
        ),
        GetPage(
          name: Routes.SCORES,
          page: () => MyScores(),
          binding: PartyBinding(),
        ),
        GetPage(
          name: Routes.SCORES_BY_PLAYER,
          page: () => ScoresByPlayer(),
          binding: PartyBinding(),
        ),
      ],
    );
  }
}

/// Names of the routes for the app
class Routes {
  static const HOME = "/";
  static const CREATE_PARTY = "/start_party";
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
