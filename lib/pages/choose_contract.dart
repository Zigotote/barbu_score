import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/player.dart';

/// A page for a player to choose his contract
class ChooseContract extends StatelessWidget {
  /// The player who needs to choose a contract
  final PlayerController player = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tour de ${player.name}"),
      ),
      body: Container(child: Text(Get.arguments.toString())),
    );
  }
}
