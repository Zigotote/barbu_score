import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/player.dart';
import '../../../utils/screen.dart';
import '../../../widgets/colored_container.dart';
import '../../../widgets/player_icon.dart';
import 'dialog_player_properties.dart';

/// Builds the field to modify the player's infos
class CreatePlayer extends StatelessWidget {
  /// The player's info
  final Player player;

  /// The function to call if player is deleted
  final Function() onRemove;

  /// The function to call to validate the player's info
  final Function(Player) onValidate;

  const CreatePlayer(
      {super.key,
      required this.player,
      required this.onRemove,
      required this.onValidate});

  /// Build the text field to change player's name
  Widget _buildPlayerTextField() {
    return TextFormField(
      textAlign: TextAlign.center,
      initialValue: player.name,
      onChanged: (value) => player.name = value,
      validator: (_) => onValidate(player),
      decoration: InputDecoration.collapsed(hintText: "Nom du joueur"),
    );
  }

  /// Builds player icon
  Widget _buildPlayerIcon(BuildContext context) {
    return TextButton(
      onPressed: () => _displayDialog(context, player, onRemove),
      child: PlayerIcon(
        image: player.image,
        color: player.color,
        size: ScreenHelper.width * 0.25,
      ),
    );
  }

  /// Displays a dialog to change the player's properties
  /// Changes are reverted if they are not validated
  void _displayDialog(
      BuildContext context, Player player, Function() onRemove) {
    showDialog(
      context: context,
      builder: (_) => DialogChangePlayerInfo(
        player: player,
        onValidate: context.pop,
        onDelete: () {
          onRemove.call();
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ColoredContainer(
          height: ScreenHelper.height * 0.15,
          color: player.color,
          child: _buildPlayerTextField(),
        ),
        Positioned(
          top: 0,
          child: _buildPlayerIcon(context),
        ),
        Positioned(
          top: ScreenHelper.height * 0.025,
          right: 0,
          width: ScreenHelper.width * 0.08,
          height: ScreenHelper.width * 0.08,
          child: IconButton.outlined(
            onPressed: onRemove,
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
