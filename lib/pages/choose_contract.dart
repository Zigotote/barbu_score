import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../commons/models/player.dart';
import '../commons/providers/contracts_manager.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/utils/router_extension.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/my_appbar.dart';
import '../main.dart';
import 'rules/models/rules_page_name.dart';

/// A page for a player to choose his contract
class ChooseContract extends ConsumerWidget {
  const ChooseContract({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Player player = ref.watch(playGameProvider).currentPlayer;
    final contractsManager = ref.watch(contractsManagerProvider);
    return DefaultPage(
      appBar: MyPlayerAppBar(
        player: player,
        context: context,
        trailing: IconButton.outlined(
          tooltip: context.l10n.rules,
          onPressed: () => context.pushNamed(
            Routes.rules,
            queryParameters: {
              MyGoRouterState.rulesPage: RulesPageName.contractRules.name
            },
          ),
          icon: Icon(Icons.question_mark_outlined),
        ),
      ),
      hasBackground: true,
      content: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: MyGrid(
          children: contractsManager.activeContracts
              .map(
                (contract) => ElevatedButton(
                  key: Key(contract.name),
                  onPressed: player.hasPlayedContract(contract)
                      ? null
                      : () {
                          ref.read(logProvider).info(
                                "ChooseContract: ${player.name} choose ${contract.name}",
                              );
                          context.push(
                            contractsManager.getScoresRoute(contract),
                          );
                        },
                  child: Text(
                    context.l10n.contractName(contract),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      bottomWidget: ElevatedButton(
        child: Text(context.l10n.scores),
        onPressed: () => context.push(Routes.scores),
      ),
    );
  }
}
