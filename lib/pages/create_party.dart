import 'package:barbu_score/utils/storage.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_players.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/colored_container.dart';
import '../widgets/dialog_player_properties.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_icon.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<CreatePlayersController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// The card that has been flipped
  FlipCardState? _flippedCard;

  /// Removes the player at the given index
  void _removePlayer(PlayerController player) {
    _flippedCard = null;
    controller.removePlayer(player);
  }

  /// Unflips the current flipped button
  void _unflipCard() {
    _flippedCard?.toggleCard();
    _flippedCard = null;
  }

  /// Builds the field to modify the player's infos
  Widget _buildPlayerField(int index) {
    PlayerController player = controller.players[index];
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(
          () => ColoredContainer(
            height: Get.height * 0.19,
            color: player.color,
            child: _buildPlayerTextField(player),
          ),
        ),
        Positioned(
          top: 0,
          child: _buildPlayerIcon(player),
        ),
      ],
    );
  }

  /// Build the text field to change player's name
  Widget _buildPlayerTextField(PlayerController player) {
    return TextFormField(
      textAlign: TextAlign.center,
      initialValue: player.name,
      onTap: () => _unflipCard(),
      onChanged: (value) => player.name = value,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Indiquer un nom.";
        } else if (controller.isDuplicateName(player)) {
          return "Ce nom est déjà pris.";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Nom du joueur",
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  /// Builds player icon
  Widget _buildPlayerIcon(PlayerController player) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return FlipCard(
      key: cardKey,
      front: OutlinedButton(
        onPressed: () {
          _unflipCard();
          _displayDialog(player);
        },
        onLongPress: () {
          _flippedCard?.toggleCard();
          _flippedCard = cardKey.currentState;
          _flippedCard!.toggleCard();
        },
        child: Obx(
          () => PlayerIcon(
            image: player.image,
            color: player.color,
            size: Get.width * 0.25,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
      ),
      back: OutlinedButton(
        onPressed: () => _removePlayer(player),
        child: Icon(
          Icons.delete_forever_outlined,
          size: Get.width * 0.2,
          color: Get.theme.scaffoldBackgroundColor,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Get.theme.errorColor,
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  /// Displays a dialog to change the player's properties
  /// Changes are reverted if they are not validated
  void _displayDialog(PlayerController player) {
    bool changesValidated = false;
    Color previousColor = player.color;
    String previousImage = player.image;
    Get.dialog(
      DialogChangePlayerInfo(
        player: player,
        onValidate: () {
          Get.back();
          changesValidated = true;
        },
        onDelete: () {
          controller.removePlayer(player);
          Get.back();
        },
      ),
    ).then((_) {
      if (!changesValidated) {
        player.color = previousColor;
        player.image = previousImage;
      }
    });
  }

  /// Builds the button to add a player
  Widget _buildAddPlayerButton() {
    return Container(
      margin: EdgeInsets.all(32),
      child: OutlinedButton(
        onPressed: () => controller.addPlayer(),
        child: Icon(
          Icons.add,
          size: Get.width * 0.1,
          semanticLabel: "Ajouter un joueur",
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Get.theme.colorScheme.onSurface,
            style: BorderStyle.solid,
            width: 2,
          ),
          fixedSize: Size(Get.width * 0.1, Get.width * 0.1),
        ),
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
    return GestureDetector(
      onTap: () => _unflipCard(),
      child: DefaultPage(
        title: "Créer les joueurs",
        content: Form(
          key: _formKey,
          child: Obx(
            () => MyGrid(
              mainAxisExtent: Get.height * 0.2,
              itemCount:
                  controller.nbPlayers < CreatePlayersController.NB_PLAYERS_MAX
                      ? controller.nbPlayers + 1
                      : controller.nbPlayers,
              itemBuilder: (_, index) {
                if (index < controller.nbPlayers) {
                  return _buildPlayerField(index);
                } else {
                  return _buildAddPlayerButton();
                }
              },
            ),
          ),
        ),
        bottomWidget: _buildValidateButton(),
      ),
    );
  }
}
