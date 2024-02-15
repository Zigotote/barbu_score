import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

checkAccessibility(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // TODO handle this guideline
  // await expectLater($, meetsGuideline(textContrastGuideline));
}

PlayerIcon findPlayerIcon(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(PlayerIcon)).toList()[index] as PlayerIcon);
