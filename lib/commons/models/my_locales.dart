import 'dart:ui';

enum MyLocales {
  en(Locale("en")),
  fr(Locale("fr"));

  final Locale locale;

  const MyLocales(this.locale);
}
