import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/player.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/widgets/colored_container.dart';

class PlayersPlacedInGrid extends ConsumerWidget {
  const PlayersPlacedInGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.playersOrder,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        LayoutGrid(
          columnSizes: [1.fr, 1.fr],
          rowSizes: List.filled((players.length / 2).round(), auto),
          rowGap: 16,
          columnGap: 16,
          children: players
              .mapIndexed(
                (index, player) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(
                        context,
                      ).textScaler.scale(players.length >= 10 ? 24 : 12),
                      child: Text(
                        (index + 1).toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: ColoredContainer(
                        alignment: Alignment.centerLeft,
                        color: player.color,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(player.name),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
