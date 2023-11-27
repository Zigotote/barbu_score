import 'package:flutter/material.dart';

import '../../../commons/models/player.dart';
import '../../../commons/widgets/colored_container.dart';
import '../../../commons/widgets/player_icon.dart';
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
      decoration: const InputDecoration.collapsed(hintText: "Nom du joueur"),
    );
  }

  /// Builds player icon
  Widget _buildPlayerIcon(BuildContext context, double size) {
    return TextButton(
      onPressed: () => _displayDialog(context, player, onRemove),
      child: PlayerIcon(
        image: player.image,
        color: player.color,
        size: size,
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
        onValidate: Navigator.of(context).pop,
        onDelete: () {
          onRemove.call();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            child: ColoredContainer(
              height: constraint.maxHeight * 0.75,
              width: constraint.maxWidth,
              color: player.color,
              child: Container(),
            ),
          ),
          Positioned(
            top: constraint.maxHeight * 0.8,
            width: constraint.maxWidth,
            child: _buildPlayerTextField(),
          ),
          Positioned(
            top: 0,
            child: _buildPlayerIcon(context, constraint.maxWidth * 0.55),
          ),
          Positioned(
            top: 24,
            right: 0,
            width: 32,
            height: 32,
            child: IconButton.outlined(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              tooltip: "Supprimer le joueur",
            ),
          ),
        ],
      );
    });
  }
}
