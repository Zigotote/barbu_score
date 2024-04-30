import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

@GenerateNiceMocks([MockSpec<MyStorage2>(), MockSpec<PlayGameNotifier>()])
import 'utils.mocks.dart';

final defaultPlayerNames = [
  "Alice",
  "Bob",
  "Charles",
  "Daniel",
  "Emy",
  "Franklin"
];
const nbPlayersByDefault = 4;

checkAccessibility(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // TODO handle this guideline
  // await expectLater($, meetsGuideline(textContrastGuideline));
}

PlayerIcon findPlayerIcon(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(PlayerIcon)).toList()[index] as PlayerIcon);

PatrolFinder findValidateScoresButton(PatrolTester $) {
  return $(ElevatedButton).containing("Valider les scores");
}

/// Mocks a storage with some active contracts
mockActiveContracts(
    MockMyStorage2 mockStorage, List<ContractsInfo> activeContracts) {
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings;
    contractSettings.isActive = activeContracts.contains(contract);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  when(mockStorage.getActiveContracts()).thenReturn(activeContracts);
}

/// Mocks a game with custom values if given
/// Returns the game
Game mockGame(MockPlayGameNotifier mockPlayGame,
    {List<AbstractContractModel>? playedContracts,
    int nbPlayers = nbPlayersByDefault}) {
  final fakeGame = Game(
    players: List.generate(
      nbPlayers,
      (index) => Player(
        name: defaultPlayerNames[index],
        color: PlayerColors.values[index],
        image: playerImages[index],
        contracts: playedContracts ?? [],
      ),
    ),
  );
  when(mockPlayGame.game).thenReturn(fakeGame);
  when(mockPlayGame.players).thenReturn(fakeGame.players);
  when(mockPlayGame.currentPlayer).thenReturn(fakeGame.players[0]);
  when(mockPlayGame.nextPlayer()).thenReturn(true);

  return fakeGame;
}
