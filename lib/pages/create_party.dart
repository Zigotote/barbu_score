import 'package:barbu_score/theme/my_themes.dart';
import 'package:barbu_score/widgets/button_full_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/my_appbar.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<PartyController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Available colors for the players
  static final _colors = [
    Colors.brown.shade700,
    Colors.lightGreen.shade700,
    Colors.yellow.shade800,
    Colors.orange.shade800,
    Colors.deepOrange.shade900,
    Colors.teal.shade900,
  ];

  /// Removes the player at the given index
  void _removePlayer(int index) {
    controller.removePlayer(index);
  }

  /// Builds the field to modify the player's name
  _buildPlayerField(int index) {
    PlayerController player = controller.players[index];
    TextEditingController txtCtrl = TextEditingController(text: player.name);
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
              color: _colors[index],
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: txtCtrl,
            textAlign: TextAlign.center,
            onChanged: (value) => player.name = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez renseigner un nom pour le joueur ${index + 1}.";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Nom du joueur",
              border: InputBorder.none,
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: OutlinedButton(
            onPressed: () => print("change perso"),
            child: Image(
              width: Get.width * 0.25,
              image: AssetImage("assets/players/player${index + 1}.png"),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: _colors[index],
              padding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    itemCount:
                        controller.nbPlayers < PartyController.NB_PLAYERS_MAX
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
    );
  }
}
