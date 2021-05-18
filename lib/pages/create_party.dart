import 'package:flutter/material.dart';

class CreateParty extends StatefulWidget {
  @override
  _CreatePartyState createState() => _CreatePartyState();
}

class _CreatePartyState extends State<CreateParty> {
  /// Form key used to validate the form
  final _formKey = GlobalKey<FormState>();

  /// Number of players for the party
  int _nbPlayers = 4;

  List<Row> _buildFields() {
    List<Row> rows = [];
    for (int index = 1; index <= _nbPlayers; index++) {
      rows.add(Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Nom du joueur",
                labelText: "Joueur $index",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez renseigner un nom pour le joueur $index.";
                }
                return null;
              },
            ),
          ),
          Visibility(
            visible: _nbPlayers > 4,
            child: TextButton(
              onPressed: () => setState(() => _nbPlayers--),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ..._buildFields(),
          Visibility(
            visible: _nbPlayers < 8,
            child: TextButton(
              onPressed: () => setState(() => _nbPlayers++),
              child: Icon(
                Icons.add_circle,
                color: Colors.green,
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
