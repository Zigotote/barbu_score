import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';

class SelectPlayerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectPlayerController());
  }
}

class OrderPlayerBinding implements Bindings {
  @override
  void dependencies() {
    PartyController c = Get.find();
    Get.lazyPut(() => OrderPlayersController(c.players));
  }
}

class IndividualScoresBinding implements Bindings {
  @override
  void dependencies() {
    PartyController c = Get.find();
    Get.lazyPut(() => IndividualScoresController(c.players));
  }
}
