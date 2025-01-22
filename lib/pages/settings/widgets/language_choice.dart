import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/config/locale_provider.dart';
import '../../../l10n/config/my_locales.dart';

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
    selectedIndex = ref.read(localeProvider) == MyLocales.fr.locale ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Langue"),
        Stack(
          alignment: Alignment.center,
          children: [
            Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  width: optionSize,
                  height: optionSize,
                  child: IconButton.outlined(
                    onPressed: () {
                      ref
                          .read(localeProvider.notifier)
                          .changeLocale(MyLocales.fr.locale);
                      setState(() => selectedIndex = 0);
                    },
                    icon: Image.asset("assets/flags/flag_french.png"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  width: optionSize,
                  height: optionSize,
                  child: IconButton.outlined(
                    onPressed: () {
                      ref
                          .read(localeProvider.notifier)
                          .changeLocale(MyLocales.en.locale);
                      setState(() => selectedIndex = 1);
                    },
                    icon: Image.asset("assets/flags/flag_english.png"),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              left: optionSize * selectedIndex,
              width: optionSize,
              height: optionSize,
              duration: const Duration(milliseconds: 900),
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
