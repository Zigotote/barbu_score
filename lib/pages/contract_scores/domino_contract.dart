import 'dart:math';

import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_list_layouts.dart';
import '../../commons/widgets/my_subtitle.dart';
import '../../main.dart';
import 'widgets/rules_button.dart';

/// A page to fill the scores for a domino contract
class DominoContractPage extends ConsumerStatefulWidget {
  const DominoContractPage({super.key});

  @override
  ConsumerState<DominoContractPage> createState() => _DominoContractPageState();
}

enum PageVersion { buttons, buttonsWithInsert, dropdown }

class _DominoContractPageState extends ConsumerState<DominoContractPage> {
  PageVersion tmpVersion = PageVersion.buttons;

  /// The ordered list of players
  List<String> orderedPlayerNames = [];
  Map<String, int> orderedPlayers = {};
  late List<TextEditingController> tmpControllers;

  @override
  void initState() {
    super.initState();
    tmpControllers = List.generate(
      ref.read(playGameProvider).players.length,
      (_) => TextEditingController(),
    );
  }

  /// Build player's list
  Widget _buildFields(List<Player> players) {
    return switch (tmpVersion) {
      PageVersion.buttons => _buildFieldsV1(players),
      PageVersion.buttonsWithInsert => _buildFieldsV2(players),
      PageVersion.dropdown => _buildFieldsV3(players),
    };
  }

  Widget _buildFieldsV1(List<Player> players) {
    final indicatorSize = MediaQuery.of(context).textScaler.scale(35);
    return MyGrid(
      children: players.map((player) {
        final isOrdered = orderedPlayerNames.contains(player.name);
        final playerRank = isOrdered
            ? (orderedPlayerNames.indexOf(player.name) + 1)
            : null;
        return ElevatedButtonWithIndicator(
          text: player.name,
          color: player.color,
          onPressed: () => setState(
            () => isOrdered
                ? orderedPlayerNames.remove(player.name)
                : orderedPlayerNames.add(player.name),
          ),
          indicator: isOrdered
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.convertMyColor(player.color),
                      width: 2,
                    ),
                  ),
                  height: indicatorSize,
                  width: indicatorSize,
                  child: Center(
                    child: Text(
                      playerRank.toString(),
                      semanticsLabel: context.l10n.ordinalNumber(playerRank!),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildFieldsV2(List<Player> players) {
    final indicatorSize = MediaQuery.of(context).textScaler.scale(35);
    return MyGrid(
      children: players.map((player) {
        final isOrdered = orderedPlayers.containsKey(player.name);
        final playerRank = isOrdered
            ? (orderedPlayers[player.name]! + 1)
            : null;
        return ElevatedButtonWithIndicator(
          text: player.name,
          color: player.color,
          onPressed: () {
            if (isOrdered) {
              setState(() {
                tmpControllers[orderedPlayers[player.name]!].clear();
                orderedPlayers.remove(player.name);
              });
            } else {
              int firstMissingRank = getFirstMissingRank();
              setState(() {
                tmpControllers[firstMissingRank].text = player.name;
                orderedPlayers[player.name] = firstMissingRank;
              });
            }
          },
          indicator: isOrdered
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.convertMyColor(player.color),
                      width: 2,
                    ),
                  ),
                  height: indicatorSize,
                  width: indicatorSize,
                  child: Center(
                    child: Text(
                      playerRank.toString(),
                      semanticsLabel: context.l10n.ordinalNumber(playerRank!),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildFieldsV3(List<Player> players) {
    return MyList(
      itemCount: players.length,
      itemBuilder: (_, index) {
        final orderedPlayerName = orderedPlayers.entries
            .firstWhereOrNull((entry) => entry.value == index)
            ?.key;
        return Row(
          spacing: 8,
          children: [
            SizedBox(
              width: MediaQuery.of(
                context,
              ).textScaler.scale(players.length >= 10 ? 60 : 50),
              child: Text(context.l10n.ordinalNumber(index + 1)),
            ),
            DropdownMenu(
              width: 250,
              controller: tmpControllers[index],
              dropdownMenuEntries: [
                for (var player in players.where(
                  (player) => !orderedPlayers.containsKey(player.name),
                ))
                  DropdownMenuEntry(value: player.name, label: player.name),
              ],
              onSelected: (playerName) {
                if (playerName != null) {
                  setState(() {
                    orderedPlayers.remove(orderedPlayerName);
                    orderedPlayers[playerName] = index;
                  });
                }
              },
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: orderedPlayerName != null
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.convertMyColor(
                            players
                                .firstWhere(
                                  (player) => player.name == orderedPlayerName,
                                )
                                .color,
                          ),
                        )
                      : BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              textStyle: TextStyle(
                color: orderedPlayerName != null
                    ? Theme.of(context).colorScheme.convertMyColor(
                        players
                            .firstWhere(
                              (player) => player.name == orderedPlayerName,
                            )
                            .color,
                      )
                    : null,
              ),
            ),
            if (orderedPlayerName != null)
              IconButton.outlined(
                onPressed: () => setState(() {
                  tmpControllers[index].clear();
                  orderedPlayers.remove(orderedPlayerName);
                }),
                icon: Icon(Icons.close),
              ),
          ],
        );
      },
    );
  }

  int getFirstMissingRank() {
    int firstMissingRank = orderedPlayers.length;
    for (int rank = 0; rank < orderedPlayers.length; rank++) {
      if (!orderedPlayers.containsValue(rank)) {
        firstMissingRank = rank;
        break;
      }
    }
    return firstMissingRank;
  }

  void _saveContract(BuildContext context, WidgetRef ref) {
    final contractModel = DominoContractModel(
      rankOfPlayer: orderedPlayers.isEmpty
          ? {
              for (var playerName in orderedPlayerNames)
                playerName: orderedPlayerNames.indexOf(playerName),
            }
          : orderedPlayers,
    );
    ref
        .read(logProvider)
        .info("DominoContractPage.saveContract: save $contractModel");
    final provider = ref.read(playGameProvider);
    provider.finishContract(contractModel);

    context.go(
      provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playGameProvider).players;
    const double tmpSize = 48;
    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(ContractsInfo.domino),
      ),
      content: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Version : ",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: tmpSize,
                        width: tmpSize,
                        child: IconButton(
                          onPressed: () => setState(() {
                            tmpVersion = PageVersion.buttons;
                            orderedPlayers = {};
                          }),
                          icon: Icon(Icons.looks_one_rounded),
                        ),
                      ),
                      SizedBox(
                        height: tmpSize,
                        width: tmpSize,
                        child: IconButton(
                          onPressed: () => setState(() {
                            tmpVersion = PageVersion.buttonsWithInsert;
                            orderedPlayerNames = [];
                          }),
                          icon: Icon(Icons.looks_two_rounded),
                        ),
                      ),
                      SizedBox(
                        height: tmpSize,
                        width: tmpSize,
                        child: IconButton(
                          onPressed: () => setState(() {
                            tmpVersion = PageVersion.dropdown;
                            orderedPlayerNames = [];
                          }),
                          icon: Icon(Icons.looks_3_rounded),
                        ),
                      ),
                    ],
                  ),
                  AnimatedPositioned(
                    left: tmpSize * PageVersion.values.indexOf(tmpVersion),
                    width: tmpSize,
                    height: tmpSize,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (tmpVersion == PageVersion.buttons)
            MySubtitle(
              context.l10n.dominoScoreSubtitle(
                context.l10n.ordinalNumber(
                  min(orderedPlayerNames.length + 1, players.length),
                ),
              ),
            ),
          if (tmpVersion == PageVersion.buttonsWithInsert)
            MySubtitle(
              context.l10n.dominoScoreSubtitle(
                context.l10n.ordinalNumber(
                  min(getFirstMissingRank() + 1, players.length),
                ),
              ),
            ),
          if (tmpVersion == PageVersion.dropdown)
            MySubtitle("Quel est l'ordre des joueurs ?"),
          _buildFields(players),
        ],
      ),
      bottomWidget: ElevatedButtonFullWidth(
        onPressed:
            players.length == orderedPlayerNames.length ||
                players.length == orderedPlayers.length
            ? () => _saveContract(context, ref)
            : null,
        child: Text(context.l10n.validateScores, textAlign: TextAlign.center),
      ),
    );
  }
}
