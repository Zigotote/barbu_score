import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';

/// A page to create a party by filling the names of the players
class CreateParty extends GetView<PartyController> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Removes the player at the given index
  void _removePlayer(int index) {
    controller.removePlayer(index);
  }

  /// Builds the field to modify the player's name
  _buildPlayerField(int index) {
    PlayerController player = controller.players[index];
    TextEditingController txtCtrl = TextEditingController(text: player.name);
    return Dismissible(
      key: UniqueKey(),
      child: ListTile(
        title: TextFormField(
          controller: txtCtrl,
          onChanged: (value) => player.name = value,
          maxLength: 35,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez renseigner un nom pour le joueur ${index + 1}.";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Nom du joueur",
            labelText: "Joueur ${index + 1}",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                txtCtrl.clear();
                player.name = "";
              },
            ),
          ),
        ),
        trailing: Visibility(
          visible: controller.nbPlayers > PartyController.NB_PLAYERS_MIN,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removePlayer(index),
          ),
        ),
      ),
      confirmDismiss: (confirm) =>
          Future.value(controller.nbPlayers > PartyController.NB_PLAYERS_MIN),
      onDismissed: (_) => _removePlayer(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barbu scores"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.nbPlayers,
                  itemBuilder: (_, index) {
                    return _buildPlayerField(index);
                  },
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.nbPlayers < PartyController.NB_PLAYERS_MAX,
                child: TextButton(
                  onPressed: () => controller.addPlayer(),
                  child: Icon(
                    Icons.add_circle,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Get.toNamed(
                    Routes.CHOOSE_CONTRACT,
                    arguments: controller.players.first,
                  );
                }
              },
              child: Text("Valider"),
            )
          ],
        ),
      ),
    );
  }
}
