import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/expandable_card.dart';
import 'package:barbu_score/pages/settings/widgets/full_game_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../main.dart';
import 'notifiers/device_info_provider.dart';
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
        spacing: 16,
        children: [
          ExpandableCard(
            title: context.l10n.application,
            children: [const AppThemeChoice(), const LanguageChoice()],
          ),
          FullGameSettingsWidget(),
          ExpandableCard(
            title: context.l10n.moreInfo,
            children: [
              TextButton(
                onPressed: () => context.push(Routes.about),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.about),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
              ContactButton(),
              TextButton(
                onPressed: () => InAppReview.instance.openStoreListing(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.rateApp),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomWidget: appVersion != null
          ? Text(context.l10n.appVersion(appVersion))
          : null,
    );
  }
}
