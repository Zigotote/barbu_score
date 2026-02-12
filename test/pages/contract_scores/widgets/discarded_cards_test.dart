import 'package:barbu_score/commons/utils/snackbar.dart';
import 'package:barbu_score/pages/contract_scores/widgets/discarded_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/french_material_app.dart';
import '../../../utils/utils.dart';

void main() {
  // The state of the singleton is shared during tests so the snackbar cannot be opened multiple times
  tearDown(() => SnackBarUtils.instance.isSnackBarOpen = false);

  group("#remove", () {
    patrolWidgetTest("should discard a card", ($) async {
      final mockUpdateNb = MockCallbackFunction();
      await $.pumpWidget(
        _createPage(initialNbCards: 1, mockUpdateNb: mockUpdateNb),
      );
      expect($("1"), findsOneWidget);

      await $(IconButton).containing($(Icons.remove)).last.tap();
      verify(mockUpdateNb.change(0));
    });
    patrolWidgetTest("should not discard negative number of cards", ($) async {
      final mockUpdateNb = MockCallbackFunction();
      await $.pumpWidget(_createPage(mockUpdateNb: mockUpdateNb));

      await $(IconButton).containing($(Icons.remove)).last.tap();
      verifyNever(mockUpdateNb.change(any));
    });
  });

  group("#add", () {
    patrolWidgetTest("should add a card", ($) async {
      final mockUpdateNb = MockCallbackFunction();
      await $.pumpWidget(_createPage(mockUpdateNb: mockUpdateNb));

      await $(IconButton).containing($(Icons.add)).tap();

      verify(mockUpdateNb.change(1));
    });
  });
}

Widget _createPage({
  required MockCallbackFunction mockUpdateNb,
  int? initialNbCards,
}) {
  return FrenchMaterialApp(
    home: Scaffold(
      body: DiscardedCards(
        cardName: "card",
        nbDiscardedCards: initialNbCards,
        removeCard: () => mockUpdateNb.change(0),
        addCard: () => mockUpdateNb.change(1),
      ),
    ),
  );
}
