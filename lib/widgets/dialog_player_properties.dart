import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

import '../controller/create_players.dart';
import '../controller/player.dart';
import 'player_icon.dart';

/// A dialog to change a player's informations
class DialogChangePlayerInfo extends GetWidget<CreatePlayersController> {
  /// The player to change the infos
  final PlayerController player;

  /// The function to call on changes validated
  final Function() onValidate;

  /// The function to call on deleted button pressed
  final Function() onDelete;

  DialogChangePlayerInfo(
      {required this.player, required this.onValidate, required this.onDelete});

  /// Builds the title of the widget
  Widget _buildTitle() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Obx(
          () => PlayerIcon(
            image: player.image,
            color: player.color,
            size: Get.width * 0.25,
          ),
        ),
        Positioned(
          right: -24,
          top: -16,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            child: Icon(Icons.close),
          ),
        )
      ],
    );
  }

  /// Builds the title and list of items the player can modify
  Widget _buildPropertySelection(String text, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(text, style: Get.textTheme.headline6),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items,
          ),
        ),
      ],
    );
  }

  /// Builds a button to display in the action part. It has a text, an icon and a foreground color
  ElevatedButton _buildActionButton(
      IconData icon, String text, Color color, Function() onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: color, width: 2),
        padding: EdgeInsets.all(8),
        foregroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPropertySelection(
            "Couleur",
            CreatePlayersController.colors
                .map(
                  (color) => Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Obx(
                      () => OutlinedButton(
                        onPressed: controller.availableColors.contains(color)
                            ? () => player.color = color
                            : null,
                        child: Text(
                          controller.getPlayerWithColor(color),
                          style: Get.textTheme.headline5!.copyWith(
                              color: Get.theme.scaffoldBackgroundColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: color,
                          minimumSize: Size(Get.width * 0.15, Get.width * 0.15),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          _buildPropertySelection(
            "Avatar",
            List.generate(
              CreatePlayersController.NB_PLAYERS_MAX,
              (index) =>
                  sprintf(CreatePlayersController.playerImage, [index + 1]),
            )
                .map(
                  (image) => OutlinedButton(
                    onPressed: () => player.image = image,
                    child: PlayerIcon(image: image, size: Get.width * 0.16),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      actions: [
        _buildActionButton(
          Icons.delete_forever_outlined,
          "Supprimer",
          Get.theme.errorColor,
          this.onDelete,
        ),
        _buildActionButton(
          Icons.done,
          "Valider",
          Get.theme.highlightColor,
          this.onValidate,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );
  }
}
