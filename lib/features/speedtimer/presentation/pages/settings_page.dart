import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/di.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sl<PageController>().animateToPage(1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease);
        return false;
      },
      child: Center(
        child: Text("settings page"),
      ),
    );
  }
}
