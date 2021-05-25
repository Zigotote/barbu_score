import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';

class CreateParty extends StatelessWidget {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// The players for the party
  final PartyController party = Get.put(PartyController());

  /// Removes the player at the given index
  void _removePlayer(int index) {
    party.removePlayer(index);
  }

  /// Builds the field to modify the player's name
  _buildPlayerField(int index) {
    PlayerController player = party.players[index];
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
          visible: party.nbPlayers > PartyController.NB_PLAYERS_MIN,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removePlayer(index),
          ),
        ),
      ),
      confirmDismiss: (confirm) =>
          Future.value(party.nbPlayers > PartyController.NB_PLAYERS_MIN),
      onDismissed: (_) => _removePlayer(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: party.nbPlayers,
                itemBuilder: (_, index) {
                  return _buildPlayerField(index);
                },
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: party.nbPlayers < PartyController.NB_PLAYERS_MAX,
              child: TextButton(
                onPressed: () => party.addPlayer(),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("OK"),
                  ),
                );
              }
            },
            child: Text("Valider"),
          )
        ],
      ),
    );
  }
}
