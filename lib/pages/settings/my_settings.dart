import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_game_settings_provider.dart';
import 'package:barbu_score/pages/settings/widgets/game_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../main.dart';
import 'notifiers/device_info_provider.dart';
import 'widgets/app_theme_choice.dart';
import 'widgets/contact_button.dart';
import 'widgets/language_choice.dart';

class MySettings extends ConsumerWidget {
  const MySettings({super.key});

  Semantics _buildTitle(BuildContext context, String title) {
    return Semantics(
      header: true,
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(deviceInfoProvider).value?.appVersion;
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        final newGameSettings = ref.read(changeGameSettingsProvider);
        if (newGameSettings != ref.read(storageProvider).getGameSettings()) {
          ref
              .read(storageProvider)
              .saveGameSettings(ref.read(changeGameSettingsProvider));
          ref
              .read(logProvider)
              .info("MySettings: change game settings $newGameSettings");
          ref.read(logProvider).sendAnalyticEvent("modify_game_settings");
          if (context.mounted) {
            SnackBarUtils.instance.openSnackBar(
              context: context,
              title: context.l10n.changesSaved,
              text: context.l10n.changesSavedDetails,
            );
          }
        }
      },
      child: MyDefaultPage(
        appBar: MyAppBar(Text(context.l10n.settings), context: context),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _buildTitle(context, context.l10n.application),
            MyCard(children: [const AppThemeChoice(), const LanguageChoice()]),
            _buildTitle(context, context.l10n.game),
            GameSettingsWidget(),
            _buildTitle(context, context.l10n.moreInfo),
            ElevatedButtonFullWidth(
              onPressed: () => context.push(Routes.about),
              child: Text(context.l10n.about),
            ),
            ContactButton(),
            ElevatedButtonFullWidth(
              onPressed: () => InAppReview.instance.openStoreListing(),
              child: Text(context.l10n.rateApp),
            ),
          ],
        ),
        bottomWidget: appVersion != null
            ? Text(context.l10n.appVersion(appVersion))
            : null,
      ),
    );
  }
}
