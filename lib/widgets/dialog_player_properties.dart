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
      {@required this.player,
      @required this.onValidate,
      @required this.onDelete});

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
          right: -Get.width * 0.05,
          top: -Get.width * 0.05,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            child: Icon(Icons.close),
          ),
        )
      ],
    );
  }

  /// Builds the title and list of items the player can modify
  List<Widget> _buildPropertySelection(String text, List items) {
    return [
      Text(text, style: Get.textTheme.headline6),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items,
        ),
      )
    ];
  }

  /// Builds a button to display in the action part. It has a text, an icon and a foreground color
  ElevatedButton _buildActionButton(
      IconData icon, String text, Color color, Function onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, color: color),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ..._buildPropertySelection(
            "Couleur",
            CreatePlayersController.colors
                .map(
                  (color) => Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.02),
                    child: Obx(
                      () => OutlinedButton(
                        onPressed: controller.availableColors.contains(color)
                            ? () => player.color = color
                            : null,
                        child: Text(
                          controller.getPlayerWithColor(color),
                          style: Get.textTheme.headline5.copyWith(
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
          ..._buildPropertySelection(
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
        _buildActionButton(Icons.delete_forever_outlined, "Supprimer",
            Get.theme.errorColor, this.onDelete),
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
