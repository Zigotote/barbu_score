import 'package:barbu_score/commons/utils/string_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/contract_info.dart';
import '../models/contract_settings_models.dart';
import '../models/my_locales.dart';
import '../providers/storage.dart';

extension BuildContextLocalizations on BuildContext {
  /// Returns the l10n service to translate Strings
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension MyAppLocalizations on AppLocalizations {
  /// Returns the name of the contract
  String contractName(ContractsInfo contract) {
    return switch (contract) {
      ContractsInfo.barbu => barbu,
      ContractsInfo.noHearts => noHearts,
      ContractsInfo.noQueens => noQueens,
      ContractsInfo.noTricks => noTricks,
      ContractsInfo.noLastTrick => noLastTrick,
      ContractsInfo.salad => salad,
      ContractsInfo.trumps => trumps,
      ContractsInfo.domino => domino,
    };
  }

  String detailedInvertScoreRules([int? points]) {
    if (points == null) {
      return invertScoreDetails;
    } else if (points > 0) {
      return invertScoreNegativeDetails;
    }
    return invertScorePositiveDetails;
  }

  /// Returns the detailed rules of the contract, depending on its settings
  String detailedContractRules(
    String currentPlayer,
    ContractsInfo contract,
    MyStorage storage, {
    int? nbPlayers,
  }) {
    final contractSettings = storage.getSettings(contract);
    if (contract == ContractsInfo.trumps) {
      final points = (contractSettings as ContractWithPointsSettings).points;
      return rulesTrumpsDetailed(currentPlayer, points) +
          (contractSettings.invertScore
              ? " ${detailedInvertScoreRules(points)}"
              : "");
    }
    if (contract == ContractsInfo.salad) {
      final activeContracts =
          (contractSettings as SaladContractSettings).activeContracts;
      final invertSaladScores = contractSettings.invertScore;
      final subContractsRules = activeContracts.map((c) {
        final subContractSettings =
            storage.getSettings(c) as ContractWithPointsSettings;
        final points = subContractSettings.points;
        return switch (c) {
          ContractsInfo.barbu => rulesBarbuInSalad(points),
          ContractsInfo.noHearts =>
            rulesNoHeartsInSalad(points) +
                (subContractSettings.invertScore && !invertSaladScores
                    ? ". ${detailedInvertScoreRules(points)}"
                    : ""),
          ContractsInfo.noQueens =>
            rulesNoQueensInSalad(points) +
                (subContractSettings.invertScore && !invertSaladScores
                    ? ". ${detailedInvertScoreRules(points)}"
                    : ""),
          ContractsInfo.noTricks =>
            rulesNoTricksInSalad(points) +
                (subContractSettings.invertScore && !invertSaladScores
                    ? ". ${detailedInvertScoreRules(points)}"
                    : ""),
          ContractsInfo.noLastTrick => rulesNoLastTrickInSalad(
            subContractSettings.points,
          ),
          _ => "",
        };
      });
      return "${rulesTrickRound(currentPlayer)}\n\n${rulesSaladDetailed(activeContracts.map((c) => contractName(c).toLowerCase()).join(", "), subContractsRules.join("\n"))}${invertSaladScores ? "\n${detailedInvertScoreRules()}" : ""}";
    }
    if (contract == ContractsInfo.domino) {
      return rulesDominoDetailed(
        currentPlayer,
        (contractSettings as DominoContractSettings).points[nbPlayers!]!
            .mapIndexed(
              (index, p) => "- ${ordinalNumber(index + 1)} : $p $points",
            )
            .join("\n"),
      );
    }
    return "${rulesTrickRound(currentPlayer)}\n\n${contractRules(contract, storage.getSettings(contract))}";
  }

  /// Returns the rules of the contract, depending on its settings
  String contractRules(
    ContractsInfo contract,
    AbstractContractSettings contractSettings,
  ) {
    return switch (ContractsInfo.fromName(contractSettings.name)) {
      ContractsInfo.barbu => rulesBarbu(
        (contractSettings as ContractWithPointsSettings).points,
      ),
      ContractsInfo.noHearts =>
        rulesNoHearts((contractSettings as ContractWithPointsSettings).points) +
            (contractSettings.invertScore
                ? " ${detailedInvertScoreRules(contractSettings.points)}"
                : ""),
      ContractsInfo.noQueens =>
        rulesNoQueens((contractSettings as ContractWithPointsSettings).points) +
            (contractSettings.invertScore
                ? " ${detailedInvertScoreRules(contractSettings.points)}"
                : ""),
      ContractsInfo.noTricks =>
        rulesNoTricks((contractSettings as ContractWithPointsSettings).points) +
            (contractSettings.invertScore
                ? " ${detailedInvertScoreRules(contractSettings.points)}"
                : ""),
      ContractsInfo.noLastTrick => rulesNoLastTrick(
        (contractSettings as ContractWithPointsSettings).points,
      ),
      ContractsInfo.salad =>
        rulesSalad(
              (contractSettings as SaladContractSettings).activeContracts
                  .map((c) => contractName(c).toLowerCase())
                  .join(", "),
            ) +
            (contractSettings.invertScore
                ? "\n${detailedInvertScoreRules()}"
                : ""),
      ContractsInfo.trumps =>
        rulesTrumps((contractSettings as ContractWithPointsSettings).points) +
            (contractSettings.invertScore
                ? " ${detailedInvertScoreRules(contractSettings.points)}"
                : ""),
      ContractsInfo.domino => rulesDomino,
    };
  }

  String contractPoints(ContractsInfo contract) {
    return switch (contract) {
      ContractsInfo.barbu ||
      ContractsInfo.noLastTrick => pointsOf(itemsName(contract)),
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks ||
      ContractsInfo.trumps => pointsBy(itemsName(contract)),
      ContractsInfo.salad || ContractsInfo.domino => "",
    };
  }

  /// Returns the name of the item won for this contract
  String itemsName(ContractsInfo contract) {
    return switch (contract) {
      ContractsInfo.barbu => barbu,
      ContractsInfo.noHearts => heart,
      ContractsInfo.noQueens => queen,
      ContractsInfo.noTricks || ContractsInfo.trumps => trick,
      ContractsInfo.noLastTrick => lastTrick,
      ContractsInfo.salad => salad,
      ContractsInfo.domino => domino,
    };
  }

  /// Returns a String representing the ordinal description of a number
  String ordinalNumber(int nb) {
    if (localeName.startsWith(MyLocales.fr.locale.languageCode)) {
      if (nb == 1) {
        return "1er";
      }
      return "$nbème";
    }
    if (localeName.startsWith(MyLocales.en.locale.languageCode)) {
      switch (nb % 10) {
        case 1:
          return '${nb}st';
        case 2:
          return '${nb}nd';
        case 3:
          return '${nb}rd';
        default:
          return '${nb}th';
      }
    }
    return "$nb";
  }

  /// Returns the card name from its index
  String cardName(int index) {
    return switch (index) {
      14 => ace.capitalize(),
      13 => king.capitalize(),
      12 => queen.capitalize(),
      11 => jack.capitalize(),
      _ => "$index",
    };
  }
}
