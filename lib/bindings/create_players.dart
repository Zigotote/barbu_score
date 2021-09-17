import 'package:get/get.dart';

import '../controller/create_players.dart';

class PartyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePlayersController());
  }
}
