import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/theme_view_model.dart';
import 'package:speedtimer_fltr/themes/themes.dart';
import 'package:speedtimer_fltr/ui/navigation/timer_navigation.dart';
import 'package:speedtimer_fltr/ui/screens/settings_screen/settings_view_model.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(TimerNavigation.timer);
        return false;
      },
      child: const Scaffold(
        body: SafeArea(
          child: _SettingsListWidget(),
        ),
      ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: const SettingsWidget(),
    );
  }
}

class _SettingsListWidget extends StatelessWidget {
  const _SettingsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, ThemeViewModel themeNotifier, child) {
      return ListView(
        children: [
          _SettingsListItemWidget(
              title: "Default Theme",
              onTap: () {
                themeNotifier.appTheme = AppTheme.defaultTheme;
              }),
          _SettingsListItemWidget(
              title: "Dark Theme",
              onTap: () {
                themeNotifier.appTheme = AppTheme.darkTheme;
              }),
          _SettingsListItemWidget(
              title: "Sunset Theme",
              onTap: () {
                themeNotifier.appTheme = AppTheme.sunsetTheme;
              }),
        ],
      );
    });
  }
}

class _SettingsListItemWidget extends StatelessWidget {
  const _SettingsListItemWidget({Key? key, required this.title, required this.onTap})
      : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
