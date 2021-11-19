import 'package:get/get.dart';

class SnackbarUtils {
  static void openSnackbar(String title, String text) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        text,
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
    }
  }
}
