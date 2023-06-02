import 'package:barbu_score/utils/storage.dart';
import 'package:barbu_score/widgets/custom_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../controller/create_players.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/colored_container.dart';
import '../widgets/dialog_player_properties.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_icon.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<CreatePlayersController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Removes the player at the given index
  void _removePlayer(PlayerController player) {
    controller.removePlayer(player);
  }

  /// Builds the field to modify the player's infos
  Widget _buildPlayerField(PlayerController player) {
    return Stack(
      key: ObjectKey(player),
      alignment: Alignment.center,
      children: [
        Obx(
          () => ColoredContainer(
            height: Get.height * 0.15,
            color: player.color,
            child: _buildPlayerTextField(player),
          ),
        ),
        Positioned(
          top: 0,
          child: _buildPlayerIcon(player),
        ),
        Positioned(
          top: Get.height * 0.03,
          right: 0,
          width: Get.width * 0.08,
          height: Get.width * 0.08,
          child: IconButton.outlined(
            onPressed: () => _removePlayer(player),
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  /// Build the text field to change player's name
  Widget _buildPlayerTextField(PlayerController player) {
    return TextFormField(
      textAlign: TextAlign.center,
      initialValue: player.name,
      onChanged: (value) => player.name = value,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Indiquer un nom.";
        } else if (controller.isDuplicateName(player)) {
          return "Nom déjà pris.";
        } else if (controller.isDuplicateColor(player)) {
          return "Couleur déjà prise.";
        }
        return null;
      },
      decoration: InputDecoration.collapsed(hintText: "Nom du joueur"),
    );
  }

  /// Builds player icon
  Widget _buildPlayerIcon(PlayerController player) {
    return OutlinedButtonNoBorder(
      onPressed: () => _displayDialog(player),
      child: Obx(
        () => PlayerIcon(
          image: player.image,
          color: player.color,
          size: Get.width * 0.25,
        ),
      ),
    );
  }

  /// Displays a dialog to change the player's properties
  /// Changes are reverted if they are not validated
  void _displayDialog(PlayerController player) {
    Get.dialog(
      DialogChangePlayerInfo(
        player: player,
        onValidate: Get.back,
        onDelete: () {
          controller.removePlayer(player);
          Get.back();
        },
      ),
    );
  }

  /// Builds the button to add a player
  Widget _buildAddPlayerButton() {
    return Center(
      child: IconButton.outlined(
        padding: EdgeInsets.all(16),
        onPressed: () => controller.addPlayer(),
        icon: Icon(
          Icons.add,
          semanticLabel: "Ajouter un joueur",
        ),
        iconSize: Get.width * 0.1,
      ),
    );
  }

  /// Builds the button to validate the form
  Widget _buildValidateButton() {
    return Obx(
      () => ElevatedButton(
        child: Text("Suivant"),
        onPressed: controller.isValid
            ? () {
                if (_formKey.currentState!.validate()) {
                  MyStorage().saveNbPlayers(controller.nbPlayers);
                  Get.toNamed(Routes.PREPARE_PARTY);
                }
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Créer les joueurs",
      hasLeading: true,
      content: Form(
        key: _formKey,
        child: Obx(
          () => ReorderableGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            children: controller.players.map(_buildPlayerField).toList(),
            dragStartDelay: kPressTimeout,
            footer: [
              if (controller.nbPlayers < CreatePlayersController.NB_PLAYERS_MAX)
                _buildAddPlayerButton()
            ],
            onReorder: controller.movePlayer,
          ),
        ),
      ),
      bottomWidget: _buildValidateButton(),
    );
  }
}
