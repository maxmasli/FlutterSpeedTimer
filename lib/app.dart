import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/theme/bloc/theme_bloc.dart';
import 'package:speedtimer_flutter/theme/theme_data_builder.dart';

import 'features/speedtimer/presentation/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<TimerBloc>()..add(TimerAppStartedEvent())),
        BlocProvider(
            create: (context) => sl<ThemeBloc>()..add(ThemeAppStartedEvent())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.theme,
            home: SafeArea(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: sl<PageController>(),
                children: const [
                  SettingsPage(),
                  TimerPage(),
                  ResultsPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
