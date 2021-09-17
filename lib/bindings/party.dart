import 'package:get/get.dart';

import '../controller/create_players.dart';
import '../controller/party.dart';

class PartyBinding implements Bindings {
  @override
  void dependencies() {
    CreatePlayersController c = Get.find();
    Get.lazyPut(() => PartyController(c.players));
  }
}
