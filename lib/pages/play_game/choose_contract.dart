import 'package:barbu_score/pages/play_game/notifiers/play_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../models/player.dart';
import '../../widgets/default_page.dart';
import '../../widgets/list_layouts.dart';
import 'models/contract_info.dart';
import 'models/contract_route_argument.dart';

/// A page for a player to choose his contract
class ChooseContract extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Player player = ref.watch(playGameProvider).currentPlayer;
    return DefaultPage(
      title: "Tour de ${player.name}",
      hasBackground: true,
      content: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: MyGrid(
          children: ContractsInfo.values
              .map(
                (contract) => ElevatedButton(
                  child:
                      Text(contract.displayName, textAlign: TextAlign.center),
                  onPressed: player.hasPlayedContract(contract)
                      ? null
                      : () => context.push(
                            contract.route,
                            extra:
                                ContractRouteArgument(contractInfo: contract),
                          ),
                ),
              )
              .toList(),
        ),
      ),
      bottomWidget: ElevatedButton(
        child: Text("Scores"),
        onPressed: () => context.push(Routes.SCORES),
      ),
    );
  }
}
