import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/list_layouts.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/active_contract_indicator.dart';
import 'widgets/app_theme_choice.dart';

class MySettings extends ConsumerWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              children: ContractsInfo.values.map(
                (contract) {
                  final contractSettings =
                      ref.watch(storageProvider).getSettings(contract);
                  return ElevatedButtonWithIndicator(
                    text: contract.displayName,
                    onPressed: () {
                      ref.read(logProvider).info(
                            "MySettings: modify settings for ${contract.name}",
                          );
                      SnackBarUtils.instance.closeSnackBar(context);
                      Navigator.of(context)
                          .pushNamed(
                        contract.settingsRoute,
                        arguments: contract,
                      )
                          .then((_) {
                        final settingsProvider =
                            ref.read(contractSettingsProvider(contract));
                        final newSettings = settingsProvider.settings;
                        if (contractSettings != newSettings) {
                          ref.read(logProvider).info(
                                "MySettings: save ${contract.name} settings $newSettings",
                              );
                          ref.read(logProvider).sendAnalyticEvent(
                            "Modify settings",
                            parameters: {"contract": contract.name},
                          );
                          final storage = ref.read(storageProvider);
                          storage.saveSettings(contract, newSettings);
                          if (storage.getStoredGame()?.isFinished == true) {
                            storage.deleteGame();
                          }
                          if (context.mounted) {
                            SnackBarUtils.instance.openSnackBar(
                              context: context,
                              title: "Modifications sauvegardées",
                              text:
                                  "Les changements ont été sauvegardés et sont effectifs dès maintenant.",
                            );
                          }
                          ref.invalidate(storageProvider);
                        }
                      });
                    },
                    indicator: ActiveContractIndicator(
                      isActive: contractSettings.isActive,
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
