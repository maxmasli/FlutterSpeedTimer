import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/ui/screens/results_screen/results_widget.dart';
import 'package:speedtimer_fltr/ui/screens/settings_screen/settings_widget.dart';
import 'package:speedtimer_fltr/ui/screens/timer_screen/timer_widget.dart';

abstract class TimerNavigation {
  static final routes = <String, Widget Function(BuildContext)>{
    "timer": (_) => TimerWidget.create(),
    "timer/results": (_) => ResultsWidget.create(),
    "timer/settings": (_) => SettingsWidget.create(),
  };

  static const timer = "timer";
  static const results = "timer/results";
  static const settings = "timer/settings";
}