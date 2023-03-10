import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/speedtimer/presentation/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => sl<TimerBloc>(),
      child: MaterialApp(
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
      ),
    );
  }
}
