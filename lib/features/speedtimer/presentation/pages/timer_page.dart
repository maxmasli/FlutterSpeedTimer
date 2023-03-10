import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'dart:math' as math;

import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/change_event_dialog.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TimerScrambleWidget(),
          const TimerWidget(),
          Row(
            children: const [
              TimerPlus2ButtonWidget(),
              TimerDNFButtonWidget(),
              TimerDeleteResultWidget(),
              TimerChangeEventButtonWidget(),
              TimerResultsButtonWidget(),
              TimerSettingsButtonWidget(),
            ],
          )
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return Expanded(
      child: GestureDetector(
        onPanDown: (_) => bloc.add(TimerOnTapDownEvent()),
        onPanEnd: (_) => bloc.add(TimerOnTapUpEvent()),
        child: SizedBox(
          width: double.infinity,
          child: ColoredBox(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            child: BlocBuilder<TimerBloc, TimerState>(
              buildWhen: (prev, state) =>
                  prev.timeInMillis != state.timeInMillis ||
                  prev.timerStateEnum != state.timerStateEnum ||
                  prev.currentResult != state.currentResult,
              builder: (context, state) {
                var textColor = Colors.black;
                if (state.timerStateEnum == TimerStateEnum.readyToStart) {
                  textColor = Colors.green;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        millisToString(state.timeInMillis),
                        style: TextStyle(fontSize: 60, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        TimerAvgWidget(),
                        TimerBestAvgWidget(),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TimerAvgWidget extends StatelessWidget {
  const TimerAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.avgEntity != state.avgEntity,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Avg of 5: ${state.avgEntity.stringAvg5}"),
            Text("Avg of 12: ${state.avgEntity.stringAvg12}"),
            Text("Avg of 50: ${state.avgEntity.stringAvg50}"),
            Text("Avg of 100: ${state.avgEntity.stringAvg100}"),
          ],
        );
      },
    );
  }
}

class TimerBestAvgWidget extends StatelessWidget {
  const TimerBestAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Best avg of 5: ${state.bestAvgEntity.stringAvg5}"),
            Text("Best avg of 12: ${state.bestAvgEntity.stringAvg12}"),
            Text("Best avg of 50: ${state.bestAvgEntity.stringAvg50}"),
            Text("Best avg of 100: ${state.bestAvgEntity.stringAvg100}"),
          ],
        );
      },
    );
  }
}

class TimerScrambleWidget extends StatelessWidget {
  const TimerScrambleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.scramble != state.scramble,
        builder: (context, state) {
          return Text(
            state.scramble,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}

class TimerPlus2ButtonWidget extends StatelessWidget {
  const TimerPlus2ButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.currentResult != state.currentResult,
      builder: (context, state) {
        var backgroundColor = Colors.transparent;
        if (state.currentResult != null && state.currentResult!.isPlus2) {
          backgroundColor = Colors.red;
        }
        return ElevatedButton(
          onPressed: () {
            bloc.add(const TimerPlus2Event());
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(width: 3, color: Colors.black),
            )),
          ),
          child: const Text("+2", style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}

class TimerDNFButtonWidget extends StatelessWidget {
  const TimerDNFButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.currentResult != state.currentResult,
      builder: (context, state) {
        var backgroundColor = Colors.transparent;
        if (state.currentResult != null && state.currentResult!.isDNF) {
          backgroundColor = Colors.red;
        }
        return ElevatedButton(
          onPressed: () {
            bloc.add(const TimerDNFEvent());
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(width: 3, color: Colors.black))),
          ),
          child: const Text("DNF", style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}

class TimerDeleteResultWidget extends StatelessWidget {
  const TimerDeleteResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return IconButton(
      onPressed: () {
        bloc.add(const TimerDeleteResultEvent());
      },
      icon: const Icon(Icons.delete),
    );
  }
}

class TimerChangeEventButtonWidget extends StatelessWidget {
  const TimerChangeEventButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return const ChangeEventDialog();
            });
      },
      icon: const Icon(Icons.abc),
    );
  }
}

class TimerResultsButtonWidget extends StatelessWidget {
  const TimerResultsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        sl<PageController>().animateToPage(2,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      },
      child: const Text("results"),
    );
  }
}

class TimerSettingsButtonWidget extends StatelessWidget {
  const TimerSettingsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        sl<PageController>().animateToPage(0,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      },
      child: const Text("settings"),
    );
    ;
  }
}
