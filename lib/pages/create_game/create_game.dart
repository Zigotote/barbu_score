import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/constants.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../main.dart';
import 'notifiers/create_game.dart';
import 'widgets/create_player.dart';

class CreateGame extends ConsumerWidget {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  CreateGame({super.key});

  /// Builds the button to add a player
  Widget _buildAddPlayerButton(BuildContext context, Function() addPlayer) {
    return Center(
      child: IconButton.outlined(
        padding: const EdgeInsets.all(16),
        onPressed: addPlayer,
        icon: Icon(
          Icons.add,
          semanticLabel: context.l10n.addItem(context.l10n.players),
        ),
        iconSize: 40,
      ),
    );
  }

  /// Builds the button to validate the form
  Widget _buildValidateButton(
    BuildContext context,
    WidgetRef ref,
    CreateGameNotifier provider,
  ) {
    return ElevatedButtonFullWidth(
      onPressed: provider.isValid
          ? () {
              if (_formKey.currentState!.validate()) {
                ref
                    .read(logProvider)
                    .info(
                      "CreateGame.buildValidateButton: create game with ${provider.players}",
                    );
                ref
                    .read(logProvider)
                    .sendAnalyticEvent(
                      "create_game",
                      parameters: {"nb_players": provider.players.length},
                    );

                ref.read(playGameProvider).init(provider.players);
                context.push(Routes.prepareGame);
              } else {
                ref
                    .read(logProvider)
                    .info(
                      "CreateGame.buildValidateButton: cannot create game with ${provider.players}",
                    );
              }
            }
          : null,
      child: Text(context.l10n.validate),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = ref.watch(createGameProvider);
    final hasStickyValidateButton =
        MediaQuery.orientationOf(context) == Orientation.portrait ||
        MediaQuery.sizeOf(context).height >= 768;
    return DefaultPage(
      appBar: MyAppBar(Text(context.l10n.createPlayers), context: context),
      content: Column(
        spacing: 16,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ReorderableGridView.count(
                crossAxisCount: (MediaQuery.of(context).size.width / 200)
                    .round(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
                dragStartDelay: kPressTimeout,
                childAspectRatio: 10 / 8,
                footer: [
                  if (playerProvider.players.length < kNbPlayersMax)
                    _buildAddPlayerButton(context, playerProvider.addPlayer),
                ],
                onReorder: playerProvider.movePlayer,
                children: playerProvider.players
                    .mapIndexed(
                      (index, player) => CreatePlayer(
                        key: ObjectKey(player),
                        player: player,
                        index: index,
                        onRemove: () => playerProvider.removePlayer(player),
                        onValidate: playerProvider.playerValidator,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          if (hasStickyValidateButton)
            _buildValidateButton(context, ref, playerProvider),
        ],
      ),
      bottomWidget: hasStickyValidateButton
          ? null
          : _buildValidateButton(context, ref, playerProvider),
    );
  }
}
