import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

const invertScoreNegative =
    "Si une personne remporte tout, son score devient négatif.";
const invertScorePositive =
    "Si une personne remporte tout, son score devient positif.";
const invertScore = "Si une personne remporte tout, son score est inversé.";

void main() {
  group("#contractRules", () {
    for (var contractTest in [
      (
        desc: "barbu",
        contract: ContractsInfo.barbu,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.barbu,
          points: 10,
        ),
        textRegex: RegExp(r'.*Barbu.*10.*'),
      ),
      (
        desc: "no hearts with invertScore",
        contract: ContractsInfo.noHearts,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noHearts,
          points: 5,
          invertScore: true,
        ),
        textRegex: RegExp(
          r'.*5.*coeur.*'
          '$invertScoreNegative\$',
        ),
      ),
      (
        desc: "no hearts without invertScores",
        contract: ContractsInfo.noHearts,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noHearts,
          points: 5,
          invertScore: false,
        ),
        textRegex: RegExp(
          r'.*5.*coeur.*'
          '(?<!$invertScoreNegative)\$',
        ),
      ),
      (
        desc: "no queens with invertScores",
        contract: ContractsInfo.noQueens,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noQueens,
          points: 5,
          invertScore: true,
        ),
        textRegex: RegExp(
          r'.*5.*dame.*'
          '$invertScoreNegative\$',
        ),
      ),
      (
        desc: "no queens without invertScores",
        contract: ContractsInfo.noQueens,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noQueens,
          points: 5,
          invertScore: false,
        ),
        textRegex: RegExp(
          r'.*5.*dame.*'
          '(?<!$invertScoreNegative)\$',
        ),
      ),
      (
        desc: "no tricks with invertScores",
        contract: ContractsInfo.noTricks,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noTricks,
          points: 5,
          invertScore: true,
        ),
        textRegex: RegExp(
          r'.*5.*pli.*'
          '$invertScoreNegative\$',
        ),
      ),
      (
        desc: "no tricks without invertScores",
        contract: ContractsInfo.noTricks,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noTricks,
          points: 5,
          invertScore: false,
        ),
        textRegex: RegExp(
          r'.*5.*pli.*'
          '(?<!$invertScoreNegative)\$',
        ),
      ),
      (
        desc: "no last trick",
        contract: ContractsInfo.noLastTrick,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.noLastTrick,
          points: 10,
        ),
        textRegex: RegExp(r'.*dernier pli.*10.*'),
      ),
      (
        desc: "salad with all contracts and invert score",
        contract: ContractsInfo.salad,
        settings: SaladContractSettings(
          invertScore: true,
          contracts: {
            for (var contract in SaladContractSettings.availableContracts)
              contract.name: true,
          },
        ),
        textRegex: RegExp(
          r'.*contrats barbu, sans coeurs, sans dames, sans plis, dernier\.(.|\s)*'
          '$invertScore\$',
          multiLine: true,
        ),
      ),
      (
        desc: "salad with all contracts, without invert score",
        contract: ContractsInfo.salad,
        settings: SaladContractSettings(
          contracts: {
            for (var contract in SaladContractSettings.availableContracts)
              contract.name: true,
          },
        ),
        textRegex: RegExp(
          r'.*contrats barbu, sans coeurs, sans dames, sans plis, dernier\.(.|\s)*'
          '(?<!$invertScore)\$',
          multiLine: true,
        ),
      ),
      (
        desc: "salad with some contracts",
        contract: ContractsInfo.salad,
        settings: SaladContractSettings(
          contracts: {
            for (var contract in [
              ContractsInfo.barbu,
              ContractsInfo.noHearts,
              ContractsInfo.noLastTrick,
            ])
              contract.name: true,
          },
        ),
        textRegex: RegExp(r'.*contrats barbu, sans coeurs, dernier\..*'),
      ),
      (
        desc: "trumps with invertScores",
        contract: ContractsInfo.trumps,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.trumps,
          points: -5,
          invertScore: true,
        ),
        textRegex: RegExp(
          r'.*atout.*\n.*-5.*pli.*'
          '$invertScorePositive\$',
          multiLine: true,
        ),
      ),
      (
        desc: "trumps without invertScores",
        contract: ContractsInfo.trumps,
        settings: ContractWithPointsSettings(
          contract: ContractsInfo.trumps,
          points: -5,
          invertScore: false,
        ),
        textRegex: RegExp(
          r'.*atout.*\n.*-5.*pli.*'
          '(?<!$invertScorePositive)\$',
          multiLine: true,
        ),
      ),
      (
        desc: "domino",
        contract: ContractsInfo.domino,
        settings: DominoContractSettings(
          pointsFirstPlayer: 10,
          pointsLastPlayer: 10,
        ),
        textRegex: RegExp(r'.*réussite.*'),
      ),
    ]) {
      patrolWidgetTest("should display ${contractTest.desc} rule", ($) async {
        await $.pumpWidget(
          FrenchMaterialApp(
            home: Builder(
              builder: (context) => Text(
                context.l10n.contractRules(
                  contractTest.contract,
                  contractTest.settings,
                ),
              ),
            ),
          ),
        );

        expect(find.textContaining(contractTest.textRegex), findsOneWidget);
      });
    }
  });
  group("#detailedContractRules", () {
    for (bool invertScore in [true, false]) {
      patrolWidgetTest(
        "should display trumps rules ${invertScore ? "with invert score" : ""}",
        ($) async {
          final mockStorage = MockMyStorage();
          when(mockStorage.getGameSettings()).thenReturn(GameSettings());
          when(mockStorage.getSettings(ContractsInfo.trumps)).thenReturn(
            (ContractsInfo.trumps.defaultSettings as ContractWithPointsSettings)
                .copyWith(invertScore: invertScore),
          );
          await $.pumpWidget(
            _createDetailedRulesPage(ContractsInfo.trumps, mockStorage),
          );

          expect(
            find.textContaining(
              RegExp(
                '${defaultPlayerNames[0]}'
                r'.*atout(\n|.)+-5.*pli.*',
                multiLine: true,
              ),
            ),
            findsOneWidget,
          );
          expect(
            find.textContaining("Si une personne remporte tout"),
            invertScore ? findsOneWidget : findsNothing,
          );
        },
      );
    }
    for (
      var nbPlayers = kNbPlayersMin;
      nbPlayers <= kNbPlayersMax;
      nbPlayers++
    ) {
      patrolWidgetTest("should display domino rules for $nbPlayers players", (
        $,
      ) async {
        final mockStorage = MockMyStorage();
        when(mockStorage.getGameSettings()).thenReturn(GameSettings());
        when(
          mockStorage.getSettings(ContractsInfo.domino),
        ).thenReturn(ContractsInfo.domino.defaultSettings);
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
                  r'- '
                  '$playerRankText'
                  ' : '
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
        desc: "with invert score in sub contracts",
        subContractsInvertScore: true,
        nbSubContractWithInvertScores: 3,
        saladInvertScore: false,
      ),
      (
        desc: "without invert score in sub contracts",
        subContractsInvertScore: false,
        nbSubContractWithInvertScores: 0,
        saladInvertScore: false,
      ),
      (
        desc: "with invert score in salad",
        subContractsInvertScore: true,
        nbSubContractWithInvertScores: 0,
        saladInvertScore: true,
      ),
    ]) {
      patrolWidgetTest("should display salad contract rules ${testData.desc}", (
        $,
      ) async {
        final mockStorage = MockMyStorage();
        for (var contract in SaladContractSettings.availableContracts) {
          ContractWithPointsSettings contractSettings =
              (contract.defaultSettings as ContractWithPointsSettings).copyWith(
                invertScore: testData.subContractsInvertScore,
              );
          when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
        }
        when(mockStorage.getSettings(ContractsInfo.salad)).thenReturn(
          SaladContractSettings(
            contracts: {
              for (var contract in SaladContractSettings.availableContracts)
                contract.name: true,
            },
            invertScore: testData.saladInvertScore,
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
          final subContractSettings =
              contract.defaultSettings as ContractWithPointsSettings;
          String? contractRule;
          switch (contract) {
            case ContractsInfo.barbu:
              contractRule =
                  "- le roi de coeur (Barbu) vaut ${subContractSettings.points} points";
              break;
            case ContractsInfo.noHearts:
              contractRule =
                  "- chaque coeur vaut ${subContractSettings.points} points";
              break;
            case ContractsInfo.noQueens:
              contractRule =
                  "- chaque dame vaut ${subContractSettings.points} points";
              break;
            case ContractsInfo.noTricks:
              contractRule =
                  "- chaque pli vaut ${subContractSettings.points} points";
              break;
            case ContractsInfo.noLastTrick:
              contractRule =
                  "- le dernier pli vaut ${subContractSettings.points} points";
              break;
            default:
              break;
          }
          expect(find.textContaining(contractRule!), findsOneWidget);
        }
        if (testData.subContractsInvertScore && !testData.saladInvertScore) {
          expect(
            find.textContaining(
              RegExp(
                r'(.*'
                '$invertScoreNegative\n.*){${testData.nbSubContractWithInvertScores}}(\n)?\$',
              ),
            ),
            findsOneWidget,
          );
        } else {
          expect(find.textContaining(invertScoreNegative), findsNothing);
        }
        expect(
          find.textContaining(invertScore),
          testData.saladInvertScore ? findsOne : findsNothing,
        );
      });
    }
  });
}

Widget _createDetailedRulesPage(
  ContractsInfo contract,
  MockMyStorage mockStorage, {
  int? nbPlayers,
}) {
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
