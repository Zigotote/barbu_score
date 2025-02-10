import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/my_locales.dart';
import '../../../commons/providers/locale_provider.dart';

class LanguageChoice extends ConsumerStatefulWidget {
  const LanguageChoice({super.key});

  @override
  ConsumerState<LanguageChoice> createState() => _LanguageChoiceState();
}

class _LanguageChoiceState extends ConsumerState<LanguageChoice> {
  int selectedIndex = 0;
  static const double optionSize = 60;

  @override
  void initState() {
    super.initState();
    selectedIndex = ref.read(localeProvider).languageCode ==
            MyLocales.fr.locale.languageCode
        ? 0
        : 1;
  }

  /// Builds the option depending on its index and locale
  Container _buildOption({required int index, required MyLocales locale}) {
    final tooltip = switch (locale) {
      MyLocales.fr => context.l10n.french,
      MyLocales.en => context.l10n.english,
    };
    final flag = switch (locale) {
      MyLocales.fr => "assets/flags/flag_french.png",
      MyLocales.en => "assets/flags/flag_english.png",
    };
    return Container(
      padding: const EdgeInsets.all(6),
      width: optionSize,
      height: optionSize,
      child: IconButton.outlined(
        tooltip: tooltip,
        onPressed: () {
          ref.read(localeProvider.notifier).changeLocale(locale.locale);
          setState(() => selectedIndex = index);
        },
        icon: Opacity(
          opacity: selectedIndex == index ? 1 : 0.8,
          child: Image.asset(flag),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.language),
        Stack(
          alignment: Alignment.center,
          children: [
            Wrap(
              children: [
                _buildOption(index: 0, locale: MyLocales.fr),
                _buildOption(index: 1, locale: MyLocales.en),
              ],
            ),
            AnimatedPositioned(
              left: optionSize * selectedIndex,
              width: optionSize,
              height: optionSize,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
