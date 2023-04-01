import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/change_event_dialog.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TimerChangeEventButtonWidget(),
              TimerBodyWidget(),
              TimerPenaltyWidget(),
            ],
          );
        },
      ),
    );
  }
}

class TimerBodyWidget extends StatelessWidget {
  const TimerBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: const [
          TimerSettingsButtonWidget(),
          TimerMainWidget(),
          TimerResultsButtonWidget(),
        ],
      ),
    );
  }
}

class TimerPenaltyWidget extends StatelessWidget {
  const TimerPenaltyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.timerStateEnum != state.timerStateEnum,
      builder: (context, state) {
        return Visibility(
          visible: state.timerStateEnum != TimerStateEnum.running,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                TimerPlus2ButtonWidget(),
                TimerDNFButtonWidget(),
                TimerDeleteResultWidget()
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimerMainWidget extends StatelessWidget {
  const TimerMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return Expanded(
      child: GestureDetector(
        onPanDown: (_) => bloc.add(TimerOnTapDownEvent()),
        onPanEnd: (_) => bloc.add(TimerOnTapUpEvent()),
        child: Container(
          decoration: const BoxDecoration(),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: const [
                    TimerWidget(),
                    TimerScrambleWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) =>
          prev.timeInMillis != state.timeInMillis ||
          prev.timerStateEnum != state.timerStateEnum ||
          prev.currentResult != state.currentResult,
      builder: (context, state) {
        var textColor = Theme.of(context).textTheme.bodyMedium!.color;
        if (state.timerStateEnum == TimerStateEnum.readyToStart) {
          textColor = Colors.green;
        }
        final double fontSize =
            state.timerStateEnum != TimerStateEnum.running ? 60 : 80;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    millisToString(state.timeInMillis),
                    style: TextStyle(fontSize: fontSize, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
            Text("Best solve: ${state.bestSolve?.stringTime ?? "DNF"}"),
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
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) =>
          prev.scramble != state.scramble ||
          prev.timerStateEnum != state.timerStateEnum,
      builder: (context, state) {
        return Visibility(
          visible: state.timerStateEnum != TimerStateEnum.running,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Text(
            state.scramble,
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).textTheme.bodyMedium!.color),
            textAlign: TextAlign.center,
          ),
        );
      },
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
        var backgroundColor = Theme.of(context).colorScheme.secondary;
        if (state.currentResult != null && state.currentResult!.isPlus2) {
          backgroundColor = Colors.red;
        }
        return GestureDetector(
          onTap: () {
            bloc.add(const TimerPlus2Event());
          },
          child: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              color: backgroundColor,
            ),
            child: Text(
              "+2",
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
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
        var backgroundColor = Theme.of(context).colorScheme.secondary;
        if (state.currentResult != null && state.currentResult!.isDNF) {
          backgroundColor = Colors.red;
        }
        return GestureDetector(
          onTap: () {
            bloc.add(const TimerDNFEvent());
          },
          child: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              color: backgroundColor,
            ),
            child: Text(
              "DNF",
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
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
    return GestureDetector(
      onTap: () {
        bloc.add(const TimerDeleteResultEvent());
      },
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Icon(
          Icons.delete,
          size: 30,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    );
  }
}

class TimerChangeEventButtonWidget extends StatelessWidget {
  const TimerChangeEventButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.timerStateEnum != state.timerStateEnum,
      builder: (context, state) {
        return Visibility(
          visible: state.timerStateEnum != TimerStateEnum.running,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ChangeEventDialog();
                  });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: Border.all(width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: BlocBuilder<TimerBloc, TimerState>(
                buildWhen: (prev, state) => prev.event != state.event,
                builder: (context, state) {
                  return Text(state.event.toEventString(),
                      style: TextStyle(
                          fontSize: 30,
                          color:
                              Theme.of(context).textTheme.bodyMedium!.color));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class TimerResultsButtonWidget extends StatelessWidget {
  const TimerResultsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.timerStateEnum != state.timerStateEnum,
      builder: (context, state) {
        return Visibility(
          visible: state.timerStateEnum != TimerStateEnum.running,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              onTap: () {
                sl<PageController>().animateToPage(2,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 3),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TimerSettingsButtonWidget extends StatelessWidget {
  const TimerSettingsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.timerStateEnum != state.timerStateEnum,
      builder: (context, state) {
        return Visibility(
          visible: state.timerStateEnum != TimerStateEnum.running,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            child: InkWell(
              onTap: () {
                sl<PageController>().animateToPage(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              },
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 3),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
