import 'package:barbu_score/pages/settings/widgets/contact_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/french_material_app.dart';
import '../../../utils/utils.dart';

void main() {
  patrolWidgetTest(
    "should display contact bottomsheet, which should be accessible",
    ($) async {
      await $.pumpWidget(FrenchMaterialApp(home: const ContactButton()));

      await $("Contact").tap();

      expect($("Que souhaitez-vous signaler ?"), findsOneWidget);
      await checkAccessibility($.tester);
    },
  );
}
