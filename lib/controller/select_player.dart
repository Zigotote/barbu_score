import 'package:get/get.dart';

/// A controller to manage box position to show which item is selected
class SelectPlayerController extends GetxController {
  /// The top position of the selection box
  RxDouble _topPositionSelectionBox;

  /// The left position of the selection box
  RxDouble _leftPositionSelectionBox;

  /// The index of the selected player
  RxInt _selectedPlayerIndex;

  SelectPlayerController() {
    this._selectedPlayerIndex = (-1).obs;
    this._topPositionSelectionBox = (0.0).obs;
    this._leftPositionSelectionBox = (0.0).obs;
  }

  bool get showSelectionBox => _selectedPlayerIndex.value != -1;

  double get topPositionSelectionBox => _topPositionSelectionBox.value;

  double get leftPositionSelectionBox => _leftPositionSelectionBox.value;

  int get selectedPlayerIndex => _selectedPlayerIndex.value;

  /// Sets the selected player index and adapts the box position depending on it
  set selectedPlayerIndex(int index) {
    _selectedPlayerIndex.value = index;
    if (index % 2 == 0) {
      _leftPositionSelectionBox.value = 0.0;
    } else {
      _leftPositionSelectionBox.value = Get.width * 0.48;
    }
    _topPositionSelectionBox.value =
        Get.height * 0.021 + (Get.height * 0.178) * (index ~/ 2);
  }
}
