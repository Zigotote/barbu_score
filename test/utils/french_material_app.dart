import 'package:barbu_score/commons/l10n/app_localizations.dart';
import 'package:barbu_score/commons/models/my_locales.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FrenchMaterialApp extends MaterialApp {
  FrenchMaterialApp({super.key, required Widget home})
    : super.router(
        supportedLocales: [MyLocales.fr.locale],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: GoRouter(
          routes: [GoRoute(path: "/", builder: (_, _) => home)],
        ),
      );

  FrenchMaterialApp.router({super.key, super.routerConfig})
    : super.router(
        supportedLocales: [MyLocales.fr.locale],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      );
}
