import 'package:barbu_score/commons/models/my_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FrenchMaterialApp extends MaterialApp {
  FrenchMaterialApp({super.key, super.home, super.initialRoute, super.routes})
      : super(
          supportedLocales: [MyLocales.fr.locale],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
}
