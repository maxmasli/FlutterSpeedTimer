import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/ui/navigation/timer_navigation.dart';

class SpeedTimer extends StatelessWidget {
  const SpeedTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: TimerNavigation.routes,
      initialRoute: TimerNavigation.timer,
    );
  }
}
