import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';

class ChangeEventDialog extends StatelessWidget {
  const ChangeEventDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      child: Container(
        child: const EventsWidget(),
      ),
    );
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventList = <Event>[...Event.values]
        .map((event) => EventWidget(
              event: event,
            ))
        .toList();

    return Wrap(
      alignment: WrapAlignment.center,
      children: eventList,
    );
  }
}

class EventWidget extends StatelessWidget {
  const EventWidget({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TimerBloc>().add(TimerChangeEvent(event));
        Navigator.of(context).pop();
      },
      child:
          SvgPicture.asset(getSvgAssetByEvent(event), width: 100, height: 100),
    );
  }
}
