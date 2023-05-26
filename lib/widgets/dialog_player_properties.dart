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

  /// The function to call on deleted button pressed
  final Function() onDelete;

  DialogChangePlayerInfo({required this.player, required this.onDelete});

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
    final double buttonSpacing = Get.width * 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(text, style: Get.textTheme.titleLarge),
        ),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: buttonSpacing,
          crossAxisSpacing: buttonSpacing,
          crossAxisCount: 3,
          children: items,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          height: Get.height * 0.643,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertySelection(
                "Couleur",
                CreatePlayersController.colors
                    .map(
                      (color) => Obx(
                        () => OutlinedButton(
                          onPressed: controller.availableColors.contains(color)
                              ? () => player.color = color
                              : null,
                          child: Text(
                            controller.getPlayerWithColor(color),
                            style: Get.textTheme.labelLarge!.copyWith(
                                color: Get.theme.scaffoldBackgroundColor),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: color,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16),
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
                        child: PlayerIcon(image: image, size: double.maxFinite),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          icon: Icon(Icons.delete_forever_outlined),
          label: Text("Supprimer"),
          onPressed: this.onDelete,
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Get.theme.colorScheme.error, width: 2),
            padding: EdgeInsets.all(8),
            foregroundColor: Get.theme.colorScheme.error,
          ),
        )
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
