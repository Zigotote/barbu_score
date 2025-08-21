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
      ContractsInfo.domino => domino,
    };
  }

  /// Returns the detailed rules of the contract, depending on its settings
  String detailedContractRules(
      String currentPlayer, ContractsInfo contract, MyStorage storage,
      {int? nbPlayers}) {
    final contractSettings = storage.getSettings(contract);
    if (contract == ContractsInfo.salad) {
      final activeContracts =
          (contractSettings as SaladContractSettings).activeContracts;
      final individualContractPoints = activeContracts.map((c) {
        final subContractSettings = storage.getSettings(c);
        return switch (c) {
          ContractsInfo.barbu => rulesBarbuInSalad(
              (subContractSettings as OneLooserContractSettings).points,
            ),
          ContractsInfo.noHearts => rulesNoHeartsInSalad(
                (subContractSettings as MultipleLooserContractSettings).points,
              ) +
              (subContractSettings.invertScore ? ". $invertScoreDetails" : ""),
          ContractsInfo.noQueens => rulesNoQueensInSalad(
                (subContractSettings as MultipleLooserContractSettings).points,
              ) +
              (subContractSettings.invertScore ? ". $invertScoreDetails" : ""),
          ContractsInfo.noTricks => rulesNoTricksInSalad(
                (subContractSettings as MultipleLooserContractSettings).points,
              ) +
              (subContractSettings.invertScore ? ". $invertScoreDetails" : ""),
          ContractsInfo.noLastTrick => rulesNoLastTrickInSalad(
              (subContractSettings as OneLooserContractSettings).points,
            ),
          _ => ""
        };
      });
      return "${rulesTrickRound(currentPlayer)}\n\n${rulesSaladDetailed(activeContracts.map((c) => contractName(c).toLowerCase()).join(", "), individualContractPoints.join("\n"))}${contractSettings.invertScore ? "\n$invertScoreDetails" : ""}";
    }
    if (contract == ContractsInfo.domino) {
      return rulesDominoDetailed(
        currentPlayer,
        (contractSettings as DominoContractSettings)
            .points[nbPlayers!]!
            .mapIndexed((index, p) =>
                "- ${ordinalNumber(index + 1)} $player : $p $points")
            .join("\n"),
      );
    }
    return "${rulesTrickRound(currentPlayer)}\n\n${contractRules(contractSettings)}";
  }

  /// Returns the rules of the contract, depending on its settings
  String contractRules(AbstractContractSettings contractSettings) {
    return switch (ContractsInfo.fromName(contractSettings.name)) {
      ContractsInfo.barbu =>
        rulesBarbu((contractSettings as OneLooserContractSettings).points),
      ContractsInfo.noHearts => rulesNoHearts(
            (contractSettings as MultipleLooserContractSettings).points,
          ) +
          (contractSettings.invertScore ? " $invertScoreDetails" : ""),
      ContractsInfo.noQueens => rulesNoQueens(
            (contractSettings as MultipleLooserContractSettings).points,
          ) +
          (contractSettings.invertScore ? " $invertScoreDetails" : ""),
      ContractsInfo.noTricks => rulesNoTricks(
            (contractSettings as MultipleLooserContractSettings).points,
          ) +
          (contractSettings.invertScore ? " $invertScoreDetails" : ""),
      ContractsInfo.noLastTrick => rulesNoLastTrick(
          (contractSettings as OneLooserContractSettings).points,
        ),
      ContractsInfo.salad => rulesSalad(
            (contractSettings as SaladContractSettings)
                .activeContracts
                .map((c) => contractName(c).toLowerCase())
                .join(", "),
          ) +
          (contractSettings.invertScore ? "\n$invertScoreDetails" : ""),
      ContractsInfo.domino => rulesDomino,
    };
  }

  /// Returns the name of the item won for this contract
  String itemsName(ContractsInfo contract) {
    return switch (contract) {
      ContractsInfo.noHearts => heart,
      ContractsInfo.noQueens => queen,
      ContractsInfo.noTricks => trick,
      _ => "",
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
}
