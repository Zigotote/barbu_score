import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/storage.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit trumps contract settings
class TrumpsContractSettingsPage extends StatelessWidget {
  /// The settings for the contract
  final TrumpsContractSettings _settings =
      MyStorage.getSettings(ContractsInfo.trumps);

  TrumpsContractSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ContractSettingsPage(
        contract: ContractsInfo.trumps,
        settings: _settings,
        children: [
          Text(
            "Contrats à jouer :",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...TrumpsContractSettings.availableContracts
              .map(
                (contract) => SettingQuestion(
                  label: contract.displayName,
                  input: MySwitch(
                    isActive: _settings.contracts[contract]!,
                    onChanged: (value) =>
                        _settings.contracts.update(contract, (_) => value),
                  ),
                ),
              )
              .toList(),
        ]);
  }
}
