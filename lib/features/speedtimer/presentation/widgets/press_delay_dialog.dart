import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';

class PressDelayDialog extends StatelessWidget {
  const PressDelayDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      child: SizedBox(
        height: 120,
        child: DelaySliderWidget(
          initialDelay: context.read<TimerBloc>().state.settingsEntity.delay,
        ),
      ),
    );
  }
}

class DelaySliderWidget extends StatefulWidget {
  const DelaySliderWidget({Key? key, required this.initialDelay})
      : super(key: key);

  final double initialDelay;

  @override
  State<DelaySliderWidget> createState() => _DelaySliderWidgetState();
}

class _DelaySliderWidgetState extends State<DelaySliderWidget> {
  double delay = 0;

  @override
  void initState() {
    delay = widget.initialDelay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.black,
        ),
        valueIndicatorColor: Colors.black12,
      ),
      child: Slider(
        activeColor: Colors.black,
        inactiveColor: Colors.black26,
        value: delay,
        onChanged: (newDelay) {
          setState(() {
            delay = newDelay;
          });
        },
        onChangeEnd: (newDelay) {
          bloc.add(TimerSetDelayEvent(newDelay));
        },
        min: 0,
        max: 1,
        divisions: 10,
        label: "$delay",
      ),
    );
    ;
  }
}
