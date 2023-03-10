import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/press_delay_dialog.dart';

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
      child: Scaffold(
        body: ListView(
          children: [
            ListTile(
              title: Text("Press delay"),
              subtitle: Text("subtitle"),
              onTap: () {
                showDialog(context: context, builder: (_) {
                  return PressDelayDialog();
                });
              },
            )
          ],
        ),
      )
    );
  }
}
