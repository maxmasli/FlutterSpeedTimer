import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/speedtimer/presentation/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = PageController(
      initialPage: 1,
    );
    return BlocProvider(
      create: (context) => sl<TimerBloc>(),
      child: MaterialApp(
        home: SafeArea(
          child: BlocBuilder<TimerBloc, TimerState>(
            buildWhen: (prev, state) => prev.timerStateEnum != state.timerStateEnum,
            builder: (context, state) {
              return PageView(
                physics: state.timerStateEnum ==
                    TimerStateEnum.stop
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                controller: controller,
                children: const [
                  SettingsPage(),
                  TimerPage(),
                  ResultsPage(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
