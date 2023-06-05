import 'package:barbu_score/theme/my_themes.dart';
import 'package:barbu_score/widgets/custom_buttons.dart';
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

  /// The function to call on validated button pressed
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
          child: OutlinedButtonNoBorder(
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

  ElevatedButton _buildActionButton(
      IconData icon, String text, Color color, Function() action) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: action,
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
                        () => OutlinedButtonNoBorder(
                          backgroundColor: color,
                          onPressed: () => player.color = color,
                          child: Text(
                            controller.getPlayersWithColor(color),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.labelLarge!.copyWith(
                                color: Get.theme.scaffoldBackgroundColor),
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
                      (image) => OutlinedButtonNoBorder(
                        onPressed: () => player.image = image,
                        child: PlayerIcon(image: image, size: double.maxFinite),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      actions: [
        _buildActionButton(
          Icons.done,
          "Valider",
          Get.theme.colorScheme.successColor,
          this.onValidate,
        ),
        _buildActionButton(
          Icons.delete_forever_outlined,
          "Supprimer",
          Get.theme.colorScheme.error,
          this.onDelete,
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
