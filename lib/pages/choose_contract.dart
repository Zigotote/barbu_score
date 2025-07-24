import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../commons/models/player.dart';
import '../commons/providers/contracts_manager.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/my_appbar.dart';
import '../main.dart';

/// A page for a player to choose his contract
class ChooseContract extends ConsumerWidget {
  const ChooseContract({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Player player = ref.watch(playGameProvider).currentPlayer;
    return DefaultPage(
      appBar: MyPlayerAppBar(player: player, context: context),
      hasBackground: true,
      content: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: MyGrid(
          children: ref
              .read(contractsManagerProvider)
              .activeContracts
              .map(
                (contract) => ElevatedButton(
                  key: Key(contract.name),
                  onPressed: player.hasPlayedContract(contract)
                      ? null
                      : () {
                          ref.read(logProvider).info(
                                "ChooseContract: ${player.name} choose ${contract.name}",
                              );
                          context.push(contract.scoreRoute);
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
