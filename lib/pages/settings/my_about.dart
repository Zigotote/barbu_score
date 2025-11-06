import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/utils/player_icon_properties.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/player_icon.dart';
import 'widgets/contact_button.dart';

class MyAbout extends ConsumerWidget {
  const MyAbout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyDefaultPage(
      appBar: MyAppBar(Text(context.l10n.about), context: context),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(context.l10n.aboutTheApp),
          Text(context.l10n.aboutTheTeam),
          Row(
            spacing: 8,
            children: [
              PlayerIcon(image: oceaneImagePath, color: MyThemeColors.purple),
              Flexible(child: Text(context.l10n.aboutOceane)),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              PlayerIcon(image: leaImagePath, color: MyThemeColors.orange),
              Flexible(child: Text(context.l10n.aboutLea)),
            ],
          ),
          Text(context.l10n.askForFeedback),
          ContactButton(),
        ],
      ),
    );
  }
}
