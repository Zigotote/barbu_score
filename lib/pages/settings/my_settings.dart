import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_list_layouts.dart';
import '../../main.dart';
import 'notifiers/device_info_provider.dart';
import 'widgets/active_contract_indicator.dart';
import 'widgets/app_theme_choice.dart';
import 'widgets/contact_button.dart';
import 'widgets/language_choice.dart';

class MySettings extends ConsumerWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(deviceInfoProvider).value?.appVersion;
    return MyDefaultPage(
      appBar: MyAppBar(Text(context.l10n.settings), context: context),
      content: Column(
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
            children: ContractsInfo.values.map((contract) {
              final contractSettings = ref
                  .watch(storageProvider)
                  .getSettings(contract);
              return ElevatedButtonWithIndicator(
                key: Key(contract.name),
                text: context.l10n.contractName(contract),
                onPressed: () {
                  ref
                      .read(logProvider)
                      .info("MySettings: open settings for ${contract.name}");
                  SnackBarUtils.instance.closeSnackBar(context);
                  context.push(contract.settingsRoute).then((_) {
                    final storage = ref.read(storageProvider);
                    final newSettings = storage.getSettings(contract);
                    if (contractSettings != newSettings) {
                      if (storage.getStoredGame()?.isFinished == true) {
                        storage.deleteGame();
                      }
                      if (context.mounted) {
                        SnackBarUtils.instance.openSnackBar(
                          context: context,
                          title: context.l10n.changesSaved,
                          text: context.l10n.changesSavedDetails,
                        );
                      }
                    }
                  });
                },
                indicator: ActiveContractIndicator(
                  isActive: contractSettings.isActive,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              context.l10n.moreInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButtonFullWidth(
            onPressed: () => context.push(Routes.about),
            child: Text(context.l10n.about),
          ),
          const SizedBox(height: 24),
          ContactButton(),
          const SizedBox(height: 24),
          ElevatedButtonFullWidth(
            onPressed: () => InAppReview.instance.openStoreListing(),
            child: Text(context.l10n.rateApp),
          ),
        ],
      ),
      bottomWidget: appVersion != null
          ? Text(context.l10n.appVersion(appVersion))
          : null,
    );
  }
}
