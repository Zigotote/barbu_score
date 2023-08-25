import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/list_layouts.dart';
import 'widgets/app_theme_choice.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Paramètres",
      hasLeading: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppThemeChoice(),
          const Text("Paramètres des contrats"),
          const SizedBox(height: 24),
          Expanded(
            child: MyGrid(
              isScrollable: false,
              children: ContractsInfo.values
                  .where((contract) => contract.settingsRoute != null)
                  .map(
                    (contract) => ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          contract.settingsRoute!,
                          arguments: contract),
                      child: Text(
                        contract.displayName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
