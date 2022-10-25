import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/theme_view_model.dart';
import 'package:speedtimer_fltr/themes/themes.dart';
import 'package:speedtimer_fltr/ui/navigation/timer_navigation.dart';

class SpeedTimer extends StatelessWidget {
  const SpeedTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, ThemeViewModel themeNotifier, child) {
          return MaterialApp(
            theme: _getTheme(themeNotifier.appTheme),
            routes: TimerNavigation.routes,
            initialRoute: TimerNavigation.timer,
          );
        },
      ),
    );
  }

  ThemeData _getTheme(AppTheme theme)  {
    switch (theme) {
      case AppTheme.defaultTheme: return defaultTheme();
      case AppTheme.darkTheme: return darkTheme();
      case AppTheme.sunsetTheme: return sunsetTheme();
      default: return defaultTheme();
    }
  }
}
