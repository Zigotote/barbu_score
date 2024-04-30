import 'package:collection/collection.dart';

import '../models/contract_models.dart';
import '../models/contract_settings_models.dart';

/// Calculates the scores from a list of contracts and settings. Returns null if all contracts do not have settings.
Map<String, int>? calculateTotalScores(List<AbstractContractModel> contracts,
    List<AbstractContractSettings> settings) {
  if (contracts.any((contract) =>
      settings.none((setting) => setting.name == contract.name))) {
    return null;
  }
  return contracts
      .map(
        (subContract) => subContract.scores(
          settings.firstWhere((setting) => setting.name == subContract.name),
        ),
      )
      .reduce(
        (scores, subContractScores) => scores
          ?..updateAll(
            (player, playerScores) =>
                playerScores += subContractScores![player]!,
          ),
      );
}

/// Sums all the scores in the list
Map<String, int>? sumScores(List<Map<String, int>?> playerScores) {
  return playerScores.reduce(
    (scores, contractScore) => scores == null
        ? contractScore
        : (scores
          ..updateAll(
            (player, playerScores) => contractScore == null
                ? playerScores
                : playerScores += contractScore[player]!,
          )),
  );
}
