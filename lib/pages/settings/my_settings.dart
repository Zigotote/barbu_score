import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/my_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(deviceInfoProvider).value?.appVersion;
    return MyDefaultPage(
      appBar: MyAppBar(Text(context.l10n.settings), context: context),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySectionTitle(context.l10n.application),
          SizedBox(height: 16),
          Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  const AppThemeChoice(),
                  Divider(),
                  const LanguageChoice(),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          MySectionTitle(context.l10n.moreInfo),
          SizedBox(height: 16),
          ElevatedButtonFullWidth(
            onPressed: () => context.push(Routes.about),
            child: Text(context.l10n.about),
          ),
          SizedBox(height: 16),
          ContactButton(),
          SizedBox(height: 16),
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
