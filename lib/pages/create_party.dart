import 'package:barbu_score/utils/storage.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  Widget _buildPlayerField(PlayerController player) {
    return Stack(
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
          backgroundColor: Get.theme.colorScheme.error,
          padding: EdgeInsets.all(8),
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
        style: Get.theme.iconButtonTheme.style?.copyWith(
          side: MaterialStatePropertyAll(
            BorderSide(color: Get.theme.colorScheme.onSurface, width: 2),
          ),
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
        hasLeading: true,
        content: Form(
          key: _formKey,
          child: Obx(
            () => GridView.extent(
              maxCrossAxisExtent: Get.width * 0.5,
              crossAxisSpacing: 16,
              children: [
                ...controller.players
                    .map((player) => _buildPlayerField(player)),
                if (controller.nbPlayers <
                    CreatePlayersController.NB_PLAYERS_MAX)
                  _buildAddPlayerButton()
              ],
            ),
          ),
        ),
        bottomWidget: _buildValidateButton(),
      ),
    );
  }
}
