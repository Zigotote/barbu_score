import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/models/player.dart';
import '../commons/providers/contracts_manager.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../main.dart';
import 'contract_scores/models/contract_route_argument.dart';

/// A page for a player to choose his contract
class ChooseContract extends ConsumerWidget {
  const ChooseContract({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Player player = ref.watch(playGameProvider).currentPlayer;
    return DefaultPage(
      title: "Tour de ${player.name}",
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
                          Navigator.of(context).pushNamed(
                            contract.scoreRoute,
                            arguments:
                                ContractRouteArgument(contractInfo: contract),
                          );
                        },
                  child: Text(
                    contract.displayName,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      bottomWidget: ElevatedButton(
        child: const Text("Scores"),
        onPressed: () => Navigator.of(context).pushNamed(Routes.scores),
      ),
    );
  }
}
