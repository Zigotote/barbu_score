import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  for (var numberValueTest in [1, -1]) {
    patrolWidgetTest("should call on changed when enter $numberValueTest",
        ($) async {
      final mockOnChanged = _MockCallbackFunction();
      await $.pumpWidgetAndSettle(_createApp(mockOnChanged));

      await $(NumberInput).enterText("$numberValueTest");

      verify(mockOnChanged.change(numberValueTest));
    });
  }
  for (var nanValueTest in [null, "a", "", "-"]) {
    patrolWidgetTest(
        "should call on changed with 0 when enter is $nanValueTest", ($) async {
      final mockOnChanged = _MockCallbackFunction();
      await $.pumpWidgetAndSettle(_createApp(mockOnChanged));

      await $(NumberInput).enterText("$nanValueTest");

      verify(mockOnChanged.change(0));
    });
  }
}

MaterialApp _createApp(_MockCallbackFunction mockOnChanged) {
  return MaterialApp(
    home: Scaffold(
      body: NumberInput(points: 20, onChanged: mockOnChanged.change),
    ),
  );
}

class _MockCallbackFunction extends Mock {
  void change(dynamic e);
}
