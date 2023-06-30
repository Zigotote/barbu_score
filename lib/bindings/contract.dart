import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../pages/contract_scores/models/contract_route_argument.dart';

class SelectPlayerBinding implements Bindings {
  @override
  void dependencies() {
    SelectPlayerController controller = SelectPlayerController();
    final ContractRouteArgument routeArgument = Get.arguments;
    if (routeArgument.isForModification) {
      String playerWithItem = routeArgument.contractValues!.playerItems.entries
          .firstWhere((playerItem) => playerItem.value == 1)
          .key;
      int selectedPlayer = Get.find<PartyController>()
          .players
          .indexWhere((player) => player.name == playerWithItem);
      controller = SelectPlayerController(defaultIndex: selectedPlayer);
    }
    Get.lazyPut(() => controller);
  }
}

class OrderPlayerBinding implements Bindings {
  @override
  void dependencies() {
    PartyController party = Get.find();
    List<PlayerController> orderedPlayers = party.players.toList();
    final ContractRouteArgument routeArgument = Get.arguments;
    if (routeArgument.isForModification) {
      routeArgument.contractValues!.playerItems.entries.forEach((playerRank) {
        orderedPlayers[playerRank.value] =
            party.players.firstWhere((player) => player.name == playerRank.key);
      });
    }
    Get.lazyPut(() => OrderPlayersController(orderedPlayers));
  }
}

class IndividualScoresBinding implements Bindings {
  @override
  void dependencies() {
    PartyController party = Get.find();
    Map<String, int> itemsValues;
    final ContractRouteArgument routeArgument = Get.arguments;
    if (routeArgument.isForModification) {
      itemsValues = routeArgument.contractValues!.playerItems;
    } else {
      itemsValues = Map.fromIterable(
        party.players,
        key: (player) => player.name,
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
