import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

@GenerateNiceMocks([MockSpec<MyStorage2>()])
import 'utils.mocks.dart';

final defaultPlayerNames = ["Alice", "Bob", "Charles", "Daniel"];
const nbPlayersByDefault = 4;

checkAccessibility(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // TODO handle this guideline
  // await expectLater($, meetsGuideline(textContrastGuideline));
}

PlayerIcon findPlayerIcon(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(PlayerIcon)).toList()[index] as PlayerIcon);

mockActiveContracts(
    MockMyStorage2 mockStorage, List<ContractsInfo> activeContracts) {
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings;
    contractSettings.isActive = activeContracts.contains(contract);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  when(mockStorage.getActiveContracts()).thenReturn(activeContracts);
}
