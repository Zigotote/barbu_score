import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../commons/utils/globals.dart' as globals;
import '../../commons/utils/screen.dart';
import '../../commons/widgets/default_page.dart';
import '../../main.dart';
import 'create_game_props.dart';
import 'notifiers/create_game.dart';
import 'widgets/create_player.dart';

// TODO Océane remove provider because it can be a StatefulWidget
// + check dark theme
// correct snackbar
class CreateGame extends ConsumerWidget {
  static const String playerImage = "assets/players/player%s.png";

  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  CreateGame({super.key});

  /// Builds the button to add a player
  Widget _buildAddPlayerButton(Function() addPlayer) {
    return Center(
      child: IconButton.outlined(
        padding: const EdgeInsets.all(16),
        onPressed: addPlayer,
        icon: const Icon(
          Icons.add,
          semanticLabel: "Ajouter un joueur",
        ),
        iconSize: ScreenHelper.width * 0.1,
      ),
    );
  }

  /// Builds the button to validate the form
  Widget _buildValidateButton(
      BuildContext context, WidgetRef ref, CreateGameNotifier provider) {
    return ElevatedButton(
      onPressed: provider.isValid
          ? () {
              if (_formKey.currentState!.validate()) {
                ref.read(playGameProvider).init(provider.players);
                globals.nbPlayers = provider.players.length;
                context.push(Routes.prepareGame);
              }
            }
          : null,
      child: const Text("Suivant"),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = ref.watch(createGameProvider);
    return DefaultPage(
      title: "Créer les joueurs",
      hasLeading: true,
      content: Form(
        key: _formKey,
        child: ReorderableGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          dragStartDelay: kPressTimeout,
          footer: [
            if (playerProvider.players.length < kNbPlayersMax)
              _buildAddPlayerButton(playerProvider.addPlayer)
          ],
          onReorder: playerProvider.movePlayer,
          children: playerProvider.players
              .map(
                (player) => CreatePlayer(
                  key: ObjectKey(player),
                  player: player,
                  onRemove: () => playerProvider.removePlayer(player),
                  onValidate: playerProvider.playerValidator,
                ),
              )
              .toList(),
        ),
      ),
      bottomWidget: _buildValidateButton(context, ref, playerProvider),
    );
  }
}
