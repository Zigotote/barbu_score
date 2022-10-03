import 'package:barbu_score/controller/party.dart';
import 'package:get/get.dart';

import '../controller/create_players.dart';

class CreatePlayersBinding implements Bindings {
  @override
  void dependencies() {
    Get.deleteAll();
    Get.lazyPut(() => CreatePlayersController());
  }
}
