import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_models.dart';
import '../models/route_argument.dart';

class SelectPlayerBinding implements Bindings {
  @override
  void dependencies() {
    SelectPlayerController controller = SelectPlayerController();
    final AbstractContractModel contract =
        (Get.arguments as RouteArgument).contractValues;
    if (contract != null) {
      PlayerController playerWithItem = contract.playerItems.entries
          .firstWhere((playerItem) => playerItem.value == 1)
          .key;
      int selectedPlayer =
          Get.find<PartyController>().players.indexOf(playerWithItem);
      controller = SelectPlayerController(defaultIndex: selectedPlayer);
    }
    Get.lazyPut(() => controller);
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
    PartyController party = Get.find();
    Map<PlayerController, int> itemsValues;
    final AbstractContractModel contract =
        (Get.arguments as RouteArgument).contractValues;
    if (contract != null) {
      itemsValues = contract.playerItems;
    } else {
      itemsValues = Map.fromIterable(
        party.players,
        key: (player) => player,
        value: (_) => 0,
      );
    }
    Get.lazyPut(() => IndividualScoresController(itemsValues));
  }
}

class TrumpsScoresBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrumpsScoresController());
  }
}
