import '../controller/create_players.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flip_card/flip_card.dart';

import '../controller/player.dart';
import '../main.dart';
import '../widgets/button_full_width.dart';
import '../widgets/my_appbar.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<CreatePlayersController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// The card that has been flipped
  FlipCardState flippedCard;

  /// Removes the player at the given index
  void _removePlayer(int index) {
    flippedCard = null;
    controller.removePlayer(index);
  }

  /// Unflips the current flipped button
  void _unflipCard() {
    if (flippedCard != null) {
      flippedCard.toggleCard();
      flippedCard = null;
    }
  }

  /// Builds the field to modify the player's infos
  _buildPlayerField(int index) {
    PlayerController player = controller.players[index];
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
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
          child: TextFormField(
            textAlign: TextAlign.center,
            onTap: _unflipCard,
            onChanged: (value) => player.name = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Renseigner un nom.";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Nom du joueur",
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: FlipCard(
            key: cardKey,
            front: OutlinedButton(
              onPressed: () {
                _unflipCard();
                print("change perso");
              },
              onLongPress: () {
                if (flippedCard != null) {
                  flippedCard.toggleCard();
                }
                flippedCard = cardKey.currentState;
                flippedCard.toggleCard();
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
              onPressed: () => _removePlayer(index),
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unflipCard,
      child: Scaffold(
        appBar: MyAppBar("Créer les joueurs"),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Obx(
                    () => GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Get.width * 0.05,
                      ),
                      itemCount: controller.nbPlayers <
                              CreatePlayersController.NB_PLAYERS_MAX
                          ? controller.nbPlayers + 1
                          : controller.nbPlayers,
                      itemBuilder: (_, index) {
                        if (index < controller.nbPlayers) {
                          return _buildPlayerField(index);
                        } else {
                          return Container(
                            margin: EdgeInsets.all(Get.width * 0.12),
                            child: OutlinedButton(
                              onPressed: () => controller.addPlayer(),
                              child: Icon(
                                Icons.add,
                                size: Get.width * 0.13,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.02),
                child: Stack(
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
                      right: Get.width * 0.03,
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
