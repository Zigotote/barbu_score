import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  const invertScoreRule =
      "Si un joueur remporte tout, son score devient négatif.";
  group("#contractRules", () {
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
  });
  group("#detailedContractRules", () {
    for (var nbPlayers = kNbPlayersMin;
        nbPlayers <= kNbPlayersMax;
        nbPlayers++) {
      patrolWidgetTest("should display domino rules for $nbPlayers players",
          ($) async {
        final mockStorage = MockMyStorage();
        when(mockStorage.getSettings(ContractsInfo.domino))
            .thenReturn(ContractsInfo.domino.defaultSettings);
        await $.pumpWidget(
          _createDetailedRulesPage(
            ContractsInfo.domino,
            mockStorage,
            nbPlayers: nbPlayers,
          ),
        );

        for (var playerRank = 1; playerRank <= kNbPlayersMax; playerRank++) {
          final playerRankText = playerRank == 1 ? "1er" : "$playerRankème";
          if (playerRank <= nbPlayers) {
            final playerPoints =
                (ContractsInfo.domino.defaultSettings as DominoContractSettings)
                    .points[nbPlayers]![playerRank - 1];
            expect(
              find.textContaining(
                RegExp(
                  r'- '
                  '$playerRankText'
                  ' joueur : '
                  '$playerPoints'
                  ' points',
                ),
              ),
              findsOneWidget,
            );
          } else {
            expect(find.textContaining(playerRankText), findsNothing);
          }
        }
      });
    }
    for (var testData in [
      (
        subContracts: SaladContractSettings.availableContracts,
        nbSubContractWithInvertScores: 3,
      ),
      (
        subContracts: [ContractsInfo.barbu],
        nbSubContractWithInvertScores: 0,
      ),
      (
        subContracts: [ContractsInfo.noQueens, ContractsInfo.barbu],
        nbSubContractWithInvertScores: 1,
      )
    ]) {
      for (var invertScore in [true, false]) {
        patrolWidgetTest(
            "should display salad contract rules with contracts ${testData.subContracts} ${invertScore ? "with" : "without"} invert score",
            ($) async {
          final mockStorage = MockMyStorage();
          for (var contract in SaladContractSettings.availableContracts) {
            AbstractContractSettings contractSettings = contract.defaultSettings
                .copyWith(isActive: testData.subContracts.contains(contract));
            if (contractSettings is MultipleLooserContractSettings) {
              contractSettings = contractSettings.copyWith(
                invertScore: invertScore,
              );
            }
            when(mockStorage.getSettings(contract))
                .thenReturn(contractSettings);
          }
          when(mockStorage.getSettings(ContractsInfo.salad)).thenReturn(
            SaladContractSettings(
              contracts: {
                for (var contract in SaladContractSettings.availableContracts)
                  contract.name: testData.subContracts.contains(contract)
              },
              invertScore: invertScore,
            ),
          );
          await $.pumpWidget(
            _createDetailedRulesPage(ContractsInfo.salad, mockStorage),
          );

          expect(
            find.textContaining(
              "${defaultPlayerNames[0]} démarre le premier pli",
            ),
            findsOneWidget,
          );
          for (var contract in SaladContractSettings.availableContracts) {
            final shouldBeDisplayed = testData.subContracts.contains(contract);
            String? contractRule;
            switch (contract) {
              case ContractsInfo.barbu:
                contractRule =
                    "- le roi de coeur (Barbu) vaut ${(contract.defaultSettings as OneLooserContractSettings).points} points";
                break;
              case ContractsInfo.noHearts:
                contractRule =
                    "- chaque coeur vaut ${(contract.defaultSettings as MultipleLooserContractSettings).points} points";
                break;
              case ContractsInfo.noQueens:
                contractRule =
                    "- chaque dame vaut ${(contract.defaultSettings as MultipleLooserContractSettings).points} points";
                break;
              case ContractsInfo.noTricks:
                contractRule =
                    "- chaque pli vaut ${(contract.defaultSettings as MultipleLooserContractSettings).points} points";
                break;
              case ContractsInfo.noLastTrick:
                contractRule =
                    "- le dernier pli vaut ${(contract.defaultSettings as OneLooserContractSettings).points} points";
                break;
              default:
                break;
            }
            expect(
              find.textContaining(contractRule!),
              shouldBeDisplayed ? findsOneWidget : findsNothing,
            );
          }
          if (invertScore) {
            expect(
              find.textContaining(
                RegExp(
                  r'(.*'
                  '$invertScoreRule\n.*){${testData.nbSubContractWithInvertScores}}(\n)?$invertScoreRule\$',
                ),
              ),
              findsOneWidget,
            );
          } else {
            expect(find.textContaining(invertScoreRule), findsNothing);
          }
        });
      }
    }
  });
}

Widget _createDetailedRulesPage(
    ContractsInfo contract, MockMyStorage mockStorage,
    {int? nbPlayers}) {
  return FrenchMaterialApp(
    home: Builder(
      builder: (context) => Text(
        context.l10n.detailedContractRules(
          defaultPlayerNames[0],
          contract,
          mockStorage,
          nbPlayers: nbPlayers,
        ),
      ),
    ),
  );
}
