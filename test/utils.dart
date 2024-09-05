import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:barbu_score/pages/contract_scores/notifiers/trumps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

@GenerateNiceMocks([
  MockSpec<BuildContext>(),
  MockSpec<ContractsManager>(),
  MockSpec<MyStorage>(),
  MockSpec<PlayGameNotifier>(),
  MockSpec<TrumpsNotifier>(),
])
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

final defaultBarbu = OneLooserContractModel(
  contract: ContractsInfo.barbu,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index == 0 ? 1 : 0
  },
);

final defaultNoQueens = MultipleLooserContractModel(
  contract: ContractsInfo.noQueens,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 1 : 0
  },
  nbItems: 4,
);

final defaultNoTricks = MultipleLooserContractModel(
  contract: ContractsInfo.noTricks,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 2 : 0
  },
  nbItems: 8,
);

final defaultNoHearts = MultipleLooserContractModel(
  contract: ContractsInfo.noHearts,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 2 : 0
  },
  nbItems: 8,
);

final defaultNoLastTrick = OneLooserContractModel(
  contract: ContractsInfo.noLastTrick,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index == 0 ? 1 : 0
  },
);

final defaultDomino = DominoContractModel(
  rankOfPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed) player: index
  },
);

final defaultTrumps = TrumpsContractModel(
  subContracts: [
    defaultBarbu,
    defaultNoQueens,
    defaultNoHearts,
    defaultNoLastTrick,
    defaultNoTricks
  ],
);

checkAccessibility(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // TODO handle this guideline
  // await expectLater($, meetsGuideline(textContrastGuideline));
}

/// Returns the text used to describe game in test description
String getGameStateText(Game? game) {
  return game != null
      ? game.isFinished
          ? "with finished game"
          : "with stored game"
      : "";
}

PlayerIcon findPlayerIcon(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(PlayerIcon)).toList()[index] as PlayerIcon);

PatrolFinder findValidateScoresButton(PatrolTester $) {
  return $(ElevatedButton).containing("Valider les scores");
}

/// Mocks a storage with some active contracts
mockActiveContracts(MyStorage mockStorage,
    [List<ContractsInfo> activeContracts = ContractsInfo.values]) {
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings;
    contractSettings.isActive = activeContracts.contains(contract);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  when(mockStorage.getActiveContracts()).thenReturn(activeContracts);
}

/// Creates a game with [nbPlayers] number of players, and eaach player played [playedContracts]
Game createGame(int nbPlayers, List<AbstractContractModel>? playedContracts) {
  return Game(
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
}

/// Mocks a game with custom values if given
/// Returns the game
Game mockGame(MockPlayGameNotifier mockPlayGame,
    {List<AbstractContractModel>? playedContracts,
    int nbPlayers = nbPlayersByDefault}) {
  final fakeGame = createGame(nbPlayers, playedContracts);
  when(mockPlayGame.game).thenReturn(fakeGame);
  when(mockPlayGame.players).thenReturn(fakeGame.players);
  when(mockPlayGame.currentPlayer).thenReturn(fakeGame.players[0]);
  when(mockPlayGame.nextPlayer()).thenReturn(true);

  return fakeGame;
}
