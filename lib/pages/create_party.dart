import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_players.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/dialog_player_properties.dart';
import '../widgets/my_appbar.dart';
import '../widgets/player_icon.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<CreatePlayersController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// The card that has been flipped
  FlipCardState _flippedCard;

  /// The text field focused by the user
  FocusNode _focusedTextField;

  /// Removes the player at the given index
  void _removePlayer(PlayerController player) {
    _flippedCard = null;
    controller.removePlayer(player);
  }

  /// Unflips the current flipped button
  void _unflipCard() {
    if (_flippedCard != null) {
      _flippedCard.toggleCard();
      _flippedCard = null;
    }
  }

  /// Unfocuses the previously focused text field
  void _unfocusTextField() {
    if (_focusedTextField != null) {
      _focusedTextField.unfocus();
    }
  }

  /// Builds the field to modify the player's infos
  _buildPlayerField(int index) {
    PlayerController player = controller.players[index];
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(
          () => Container(
            height: Get.height * 0.19,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: player.color,
                width: 2,
              ),
            ),
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
    FocusNode focusNode = FocusNode();
    return TextFormField(
      textAlign: TextAlign.center,
      initialValue: player.name,
      onTap: () {
        _unflipCard();
        _focusedTextField = focusNode;
      },
      onChanged: (value) => player.name = value,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Indiquer le nom du joueur.";
        }
        return null;
      },
      focusNode: focusNode,
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
          _unfocusTextField();
          if (_flippedCard != null) {
            _flippedCard.toggleCard();
          }
          _flippedCard = cardKey.currentState;
          _flippedCard.toggleCard();
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
      margin: EdgeInsets.all(Get.width * 0.12),
      child: OutlinedButton(
        onPressed: () => controller.addPlayer(),
        child: Icon(
          Icons.add,
          size: Get.width * 0.1,
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Builds the button to validate the form
  Widget _buildValidateButton() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ElevatedButtonFullWidth(
          text: "C'est parti",
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Get.toNamed(Routes.CHOOSE_CONTRACT);
            }
          },
        ),
        Positioned(
          right: Get.width * 0.1,
          child: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unflipCard();
        _unfocusTextField();
      },
      child: Scaffold(
        appBar: MyAppBar("Créer les joueurs"),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                sliver: Obx(
                  () => SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: Get.width * 0.05,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        if (index < controller.nbPlayers) {
                          return _buildPlayerField(index);
                        } else {
                          return _buildAddPlayerButton();
                        }
                      },
                      childCount: controller.nbPlayers <
                              CreatePlayersController.NB_PLAYERS_MAX
                          ? controller.nbPlayers + 1
                          : controller.nbPlayers,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: Get.height * 0.02),
                sliver: SliverToBoxAdapter(
                  child: _buildValidateButton(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
