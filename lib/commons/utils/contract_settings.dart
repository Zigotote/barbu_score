import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/settings/notifiers/contract_settings_provider.dart';
import '../models/contract_info.dart';
import '../models/contract_settings_models.dart';
import '../providers/log.dart';
import '../providers/storage.dart';
import 'snackbar.dart';

/// Service to save new contract settings, if they really changed, and notify user about it
void saveContractSettings(BuildContext context, WidgetRef ref,
    {required ContractsInfo contract,
    required AbstractContractSettings previousSettings,
    bool notifyUser = false}) {
  final settingsProvider = ref.read(contractSettingsProvider(contract));
  final newSettings = settingsProvider.settings;
  if (previousSettings != newSettings) {
    ref.read(logProvider).info(
          "MySettings: save ${contract.name} settings $newSettings",
        );
    ref.read(logProvider).sendAnalyticEvent(
      "modify_settings",
      parameters: {"contract": contract.name},
    );
    final storage = ref.read(storageProvider);
    storage.saveSettings(contract, newSettings);
    if (storage.getStoredGame()?.isFinished == true) {
      storage.deleteGame();
    }
    if (notifyUser && context.mounted) {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: context.l10n.changesSaved,
        text: context.l10n.changesSavedDetails,
      );
    }
    ref.invalidate(storageProvider);
  }
}
