import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/pages/settings/notifiers/contract_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol_finders/patrol_finders.dart';

T getContractSettingsProvider<T extends AbstractContractSettings>(
    UncontrolledProviderScope page, ContractsInfo contract) {
  return (page.container.read(contractSettingsProvider(contract)).settings
      as T);
}

bool findSwitchValue(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(Switch)).toList()[index] as Switch).value;
