import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';

main() {
  const invertScoreRule =
      "Si un joueur remporte tout, son score devient négatif.";
  for (var contractTest in [
    (
      desc: "barbu",
      contract: OneLooserContractSettings(
        contract: ContractsInfo.barbu,
        points: 10,
      ),
      textRegex: RegExp(r'.*Barbu.*10.*'),
    ),
    (
      desc: "no hearts with invertScore",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noHearts,
        points: 5,
      ),
      textRegex: RegExp(r'.*5.*coeur.*' '$invertScoreRule\$')
    ),
    (
      desc: "no hearts without invertScores",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noHearts,
        points: 5,
        invertScore: false,
      ),
      textRegex: RegExp(r'.*5.*coeur.*' '(?<!$invertScoreRule)\$')
    ),
    (
      desc: "no queens with invertScores",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noQueens,
        points: 5,
      ),
      textRegex: RegExp(r'.*5.*dame.*' '$invertScoreRule\$')
    ),
    (
      desc: "no queens without invertScores",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noQueens,
        points: 5,
        invertScore: false,
      ),
      textRegex: RegExp(r'.*5.*dame.*' '(?<!$invertScoreRule)\$')
    ),
    (
      desc: "no tricks with invertScores",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noTricks,
        points: -5,
      ),
      textRegex: RegExp(r'.*-5.*pli.*' '$invertScoreRule\$')
    ),
    (
      desc: "no tricks without invertScores",
      contract: MultipleLooserContractSettings(
        contract: ContractsInfo.noTricks,
        points: -5,
        invertScore: false,
      ),
      textRegex: RegExp(r'.*-5.*pli.*' '(?<!$invertScoreRule)\$')
    ),
    (
      desc: "no last trick",
      contract: OneLooserContractSettings(
        contract: ContractsInfo.noLastTrick,
        points: 10,
      ),
      textRegex: RegExp(r'.*dernier pli.*10.*')
    ),
    (
      desc: "salad with all contracts and invert score",
      contract: SaladContractSettings(
        invertScore: true,
        contracts: {
          for (var contract in SaladContractSettings.availableContracts)
            contract.name: true
        },
      ),
      textRegex: RegExp(
        r'.*contrats barbu, sans coeurs, sans dames, sans plis, dernier\.(.|\s)*'
        '$invertScoreRule\$',
        multiLine: true,
      )
    ),
    (
      desc: "salad with all contracts, without invert score",
      contract: SaladContractSettings(
        contracts: {
          for (var contract in SaladContractSettings.availableContracts)
            contract.name: true
        },
      ),
      textRegex: RegExp(
        r'.*contrats barbu, sans coeurs, sans dames, sans plis, dernier\.(.|\s)*'
        '(?<!$invertScoreRule)\$',
        multiLine: true,
      )
    ),
    (
      desc: "salad with some contracts",
      contract: SaladContractSettings(
        contracts: {
          for (var contract in [
            ContractsInfo.barbu,
            ContractsInfo.noHearts,
            ContractsInfo.noLastTrick
          ])
            contract.name: true
        },
      ),
      textRegex: RegExp(r'.*contrats barbu, sans coeurs, dernier\..*')
    ),
    (
      desc: "domino",
      contract: DominoContractSettings(
        pointsFirstPlayer: 10,
        pointsLastPlayer: 10,
      ),
      textRegex: RegExp(r'.*réussite.*')
    ),
  ]) {
    patrolWidgetTest("should display ${contractTest.desc} rule", ($) async {
      await $.pumpWidget(
        FrenchMaterialApp(
          home: Builder(
            builder: (context) =>
                Text(context.l10n.contractRules(contractTest.contract)),
          ),
        ),
      );

      expect(find.textContaining(contractTest.textRegex), findsOneWidget);
    });
  }
}
