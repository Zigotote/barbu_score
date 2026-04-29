import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/providers/storage.dart';

final changeContractsSettingsProvider =
    NotifierProvider.family<
      ChangeContractsSettingsProvider,
      AbstractContractSettings,
      ContractsInfo
    >(ChangeContractsSettingsProvider.new, isAutoDispose: true);

class ChangeContractsSettingsProvider
    extends Notifier<AbstractContractSettings> {
  final ContractsInfo contract;

  ChangeContractsSettingsProvider(this.contract);

  @override
  AbstractContractSettings build() {
    return ref.read(storageProvider).getSettings(contract);
  }

  void changeContractSettings(AbstractContractSettings settings) {
    state = settings;
  }
}
