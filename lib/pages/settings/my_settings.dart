import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/utils/storage.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/list_layouts.dart';
import 'widgets/active_contract_indicator.dart';
import 'widgets/app_theme_choice.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final activeContracts = MyStorage.getActiveContracts();
    return DefaultPage(
      title: "Paramètres",
      hasLeading: true,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppThemeChoice(),
            const Text("Paramètres des contrats"),
            const SizedBox(height: 24),
            MyGrid(
              isScrollable: false,
              children: ContractsInfo.values
                  .map(
                    (contract) => ElevatedButtonWithIndicator(
                      text: contract.displayName,
                      onPressed: () => Navigator.of(context).pushNamed(
                        contract.settingsRoute,
                        arguments: contract,
                      ),
                      indicator: ActiveContractIndicator(
                        isActive: activeContracts.contains(contract),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
