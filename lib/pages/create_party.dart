import 'package:barbu_score/widgets/player_icon.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

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
          Get.dialog(DialogChangePlayerInfo(player: player));
        },
        onLongPress: () {
          _unfocusTextField();
          if (_flippedCard != null) {
            _flippedCard.toggleCard();
          }
          _flippedCard = cardKey.currentState;
          _flippedCard.toggleCard();
        },
        child: PlayerIcon(
          image: player.image,
          color: player.color,
          size: Get.width * 0.25,
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

/// A dialog to change a player's informations
class DialogChangePlayerInfo extends GetWidget {
  /// The player to change the infos
  final PlayerController player;

  DialogChangePlayerInfo({this.player});

  /// Builds the title and list of items the player can modify
  List<Widget> _buildPropertySelection(String text, List items) {
    return [
      Text(text, style: Get.theme.textTheme.headline6),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items,
        ),
      )
    ];
  }

  /// Builds a button to display in the action part. It has a text, an icon and a foreground color
  ElevatedButton _buildActionButton(IconData icon, String text, Color color) {
    return ElevatedButton(
      onPressed: null,
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
      title: PlayerIcon(
        image: player.image,
        color: player.color,
        size: Get.width * 0.25,
      ),
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
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text(""),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: color,
                        minimumSize: Size(Get.width * 0.15, Get.width * 0.15),
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
                    onPressed: null,
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
        ),
        _buildActionButton(
          Icons.done,
          "Valider",
          Get.theme.highlightColor,
        ),
      ],
    );
  }
}
