import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage.dart';

final localeProvider =
    NotifierProvider<_LocaleNotifier, Locale>(_LocaleNotifier.new);

class _LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return ref.read(storageProvider).getLocale() ??
        WidgetsBinding.instance.platformDispatcher.locale;
  }

  void changeLocale(Locale locale) {
    state = locale;
    ref.read(storageProvider).saveLocale(locale);
  }
}
