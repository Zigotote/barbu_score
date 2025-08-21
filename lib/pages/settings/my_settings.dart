import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
import '../../commons/utils/contract_settings.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/list_layouts.dart';
import '../../commons/widgets/my_appbar.dart';
import 'widgets/active_contract_indicator.dart';
import 'widgets/app_theme_choice.dart';
import 'widgets/language_choice.dart';

class MySettings extends ConsumerWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultPage(
      appBar: MyAppBar(
        Text(context.l10n.settings),
        context: context,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppThemeChoice(),
            const LanguageChoice(),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(
                context.l10n.contracts,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            MyGrid(
              isScrollable: false,
              children: ContractsInfo.values.map(
                (contract) {
                  final contractSettings =
                      ref.watch(storageProvider).getSettings(contract);
                  return ElevatedButtonWithIndicator(
                    key: Key(contract.name),
                    text: context.l10n.contractName(contract),
                    onPressed: () {
                      ref.read(logProvider).info(
                            "MySettings: open settings for ${contract.name}",
                          );
                      SnackBarUtils.instance.closeSnackBar(context);
                      context.push(contract.settingsRoute).then(
                            (_) => context.mounted
                                ? saveContractSettings(
                                    context,
                                    ref,
                                    contract: contract,
                                    previousSettings: contractSettings,
                                    notifyUser: true,
                                  )
                                : null,
                          );
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
