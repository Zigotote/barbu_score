import '../controller/create_players.dart';
import 'package:get/get.dart';

class PartyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePlayersController());
  }
}
