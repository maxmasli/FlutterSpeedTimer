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
      child: const EventsWidget(),
    );
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventListWidgets = <Event>[...Event.values]
        .map((event) => EventTile(
              event: event,
            ))
        .toList();

    return Wrap(
      alignment: WrapAlignment.center,
      children: eventListWidgets,
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TimerBloc>().add(TimerChangeEvent(event));
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(getSvgAssetByEvent(event), width: 60, height: 60),
            Text(
              event.toEventString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            )
          ],
        ),
      ),
    );
  }
}
