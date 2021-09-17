import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_players.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/button_full_width.dart';
import '../widgets/my_appbar.dart';

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
        Container(
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
      onTap: () {
        _unflipCard();
        _focusedTextField = focusNode;
      },
      onChanged: (value) => player.name = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
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
          print("change perso");
        },
        onLongPress: () {
          _unfocusTextField();
          if (_flippedCard != null) {
            _flippedCard.toggleCard();
          }
          _flippedCard = cardKey.currentState;
          _flippedCard.toggleCard();
        },
        child: Image(
          width: Get.width * 0.25,
          image: AssetImage(player.image),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: player.color,
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
