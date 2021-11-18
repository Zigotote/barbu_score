import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../models/route_argument.dart';

class SelectPlayerBinding implements Bindings {
  @override
  void dependencies() {
    SelectPlayerController controller = SelectPlayerController();
    final RouteArgument routeArgument = Get.arguments;
    if (routeArgument.isForModification) {
      PlayerController playerWithItem = routeArgument
          .contractValues.playerItems.entries
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
    final RouteArgument routeArgument = Get.arguments;
    if (routeArgument.isForModification) {
      itemsValues = routeArgument.contractValues.playerItems;
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
