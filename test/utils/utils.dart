import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:barbu_score/pages/contract_scores/notifiers/salad_provider.dart';
import 'package:barbu_score/theme/my_theme_colors.dart';
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
  MockSpec<SaladNotifier>(),
  MockSpec<MyLog>()
])
import 'utils.mocks.dart';

final defaultPlayerNames = [
  "Alice",
  "Bob",
  "Charles",
  "Daniel",
  "Emy",
  "Franklin",
  "Greg",
  "Henry",
  "Izzy",
  "Jack",
];
const nbPlayersByDefault = 4;

final defaultBarbu = ContractWithPointsModel(
  contract: ContractsInfo.barbu,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index == 0 ? 1 : 0
  },
);

final defaultNoQueens = ContractWithPointsModel(
  contract: ContractsInfo.noQueens,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 1 : 0
  },
  nbItems: 4,
);

final defaultNoTricks = ContractWithPointsModel(
  contract: ContractsInfo.noTricks,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 2 : 0
  },
  nbItems: 8,
);

final defaultNoHearts = ContractWithPointsModel(
  contract: ContractsInfo.noHearts,
  itemsByPlayer: {
    for (var (index, player) in defaultPlayerNames.indexed)
      player: index < 4 ? 2 : 0
  },
  nbItems: 8,
);

final defaultNoLastTrick = ContractWithPointsModel(
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

final defaultSalad = SaladContractModel(
  subContracts: [
    defaultBarbu,
    defaultNoQueens,
    defaultNoHearts,
    defaultNoLastTrick,
    defaultNoTricks
  ],
);

Future<void> checkAccessibility(WidgetTester tester) async {
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
void mockActiveContracts(MyStorage mockStorage,
    [List<ContractsInfo> activeContracts = ContractsInfo.values]) {
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings
        .copyWith(isActive: activeContracts.contains(contract));
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  when(mockStorage.getActiveContracts()).thenReturn(activeContracts);
}

/// Creates a game with [nbPlayers] number of players, and each player played [playedContracts]
Game createGame(int nbPlayers,
    [List<AbstractContractModel> playedContracts = const []]) {
  return Game(
    players: List.generate(
      nbPlayers,
      (index) => Player(
        name: defaultPlayerNames[index],
        color: MyThemeColors.values[index],
        image: playerImages[index],
        contracts: playedContracts,
      ),
    ),
  );
}

/// Mocks a game with custom values if given
/// Returns a MockPlayGameNotifier
MockPlayGameNotifier mockPlayGameNotifier(
    {List<AbstractContractModel> playedContracts = const [],
    int nbPlayers = nbPlayersByDefault}) {
  final mockPlayGame = MockPlayGameNotifier();
  final fakeGame = createGame(nbPlayers, playedContracts);
  when(mockPlayGame.game).thenReturn(fakeGame);
  when(mockPlayGame.players).thenReturn(fakeGame.players);
  when(mockPlayGame.currentPlayer).thenReturn(fakeGame.players[0]);
  when(mockPlayGame.nextPlayer()).thenReturn(true);

  return mockPlayGame;
}
