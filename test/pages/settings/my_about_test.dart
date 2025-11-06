import 'package:barbu_score/pages/settings/my_about.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(FrenchMaterialApp(home: const MyAbout()));

    expect($("A propos"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
}
