import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

bool findSwitchValue(PatrolTester $, {int index = 0}) =>
    ($.tester.widgetList($(Switch)).toList()[index] as Switch).value;
