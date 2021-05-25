import 'package:get/get.dart';

import '../controller/party.dart';

class PartyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PartyController());
  }
}
