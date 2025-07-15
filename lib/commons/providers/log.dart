// coverage:ignore-file
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logProvider = Provider((_) => MyLog());

class MyLog {
  void info(String message) {
    try {
      FirebaseCrashlytics.instance.log(message);
    } catch (_) {
      debugPrint(message);
    }
  }

  void error(dynamic exception, {StackTrace? stackTrace}) {
    try {
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    } catch (_) {
      debugPrint(exception);
    }
  }

  void sendAnalyticEvent(String event, {Map<String, Object>? parameters}) {
    try {
      FirebaseAnalytics.instance.logEvent(name: event, parameters: parameters);
    } catch (_) {}
  }
}
