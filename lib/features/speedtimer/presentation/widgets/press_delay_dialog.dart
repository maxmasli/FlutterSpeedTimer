import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';

class PressDelayDialog extends StatelessWidget {
  const PressDelayDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    double delay = 0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.settingsEntity != state.settingsEntity,
        builder: (context, state) {
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
              ),
              valueIndicatorColor: Colors.black12
            ),
            child: Slider(
              activeColor: Colors.black,
              inactiveColor: Colors.black26,
              value: state.settingsEntity.delay,
              onChanged: (newDelay) {
                delay = newDelay;
                bloc.add(TimerSetDelayEvent(newDelay));
              },
              min: 0,
              max: 1,
              divisions: 10,
              label: "$delay",
            ),
          );
        },
      ),
    );
  }
}
