import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/providers/storage.dart';

final localeProvider =
    NotifierProvider<_LocaleNotifier, Locale>(_LocaleNotifier.new);

class _LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return ref.read(storageProvider).getLocale() ??
        PlatformDispatcher.instance.locale;
  }

  void changeLocale(Locale locale) {
    state = locale;
    ref.read(storageProvider).saveLocale(locale);
  }
}
