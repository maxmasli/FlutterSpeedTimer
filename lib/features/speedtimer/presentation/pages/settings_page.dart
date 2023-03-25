import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/press_delay_dialog.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/set_theme_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sl<PageController>().animateToPage(1,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            return ListView(
              children: [
                ListTile(
                  title: Text(
                    "Press delay",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                  subtitle: Text(
                    state.settingsEntity.delay.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return const PressDelayDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Change theme",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return const SetThemeDialog();
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
