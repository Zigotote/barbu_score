import 'package:get/get.dart';

import '../controller/contract.dart';

class SelectPlayerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectPlayerController());
  }
}
