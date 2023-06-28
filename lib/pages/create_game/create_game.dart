import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../utils/screen.dart';
import '../../main.dart';
import '../../widgets/default_page.dart';
import 'create_game_props.dart';
import 'notifiers/create_game.dart';
import 'widgets/create_player.dart';

class CreateGame extends ConsumerWidget {
  static final String playerImage = "assets/players/player%s.png";

  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Builds the button to add a player
  Widget _buildAddPlayerButton(Function() addPlayer) {
    return Center(
      child: IconButton.outlined(
        padding: EdgeInsets.all(16),
        onPressed: addPlayer,
        icon: Icon(
          Icons.add,
          semanticLabel: "Ajouter un joueur",
        ),
        iconSize: ScreenHelper.width * 0.1,
      ),
    );
  }

  /// Builds the button to validate the form
  Widget _buildValidateButton(
      BuildContext context, CreateGameNotifier provider) {
    return ElevatedButton(
      child: Text("Suivant"),
      onPressed: provider.isValid
          ? () {
              if (_formKey.currentState!.validate()) {
                //MyStorage().saveNbPlayers(_players.length);
                context.push(Routes.PREPARE_GAME);
              }
            }
          : null,
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
          dragStartDelay: kPressTimeout,
          footer: [
            if (playerProvider.players.length < kNbPlayersMax)
              _buildAddPlayerButton(playerProvider.addPlayer)
          ],
          onReorder: playerProvider.movePlayer,
        ),
      ),
      bottomWidget: _buildValidateButton(context, playerProvider),
    );
  }
}
