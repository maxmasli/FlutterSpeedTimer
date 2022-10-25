import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/resources/resources.dart';
import 'package:speedtimer_fltr/resources/strings.dart';
import 'package:speedtimer_fltr/ui/interfaces/EventChangeable.dart';

class EventDialogWidget<T extends EventChangeable> extends StatelessWidget {
  const EventDialogWidget({Key? key, required this.parentContext}) : super(key: key);

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final viewModel = parentContext.read<T>();
    return AlertDialog(
      title: const Text(Strings.chooseEvent),
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              viewModel.setEvent(Event.event2by2);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(Svgs.icon2by2, width: 70, height: 70),
            ),
          ),
          GestureDetector(
            onTap: () {
              viewModel.setEvent(Event.event3by3);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(Svgs.icon3by3, width: 70, height: 70),
            ),
          ),
          GestureDetector(
            onTap: () {
              viewModel.setEvent(Event.eventPyra);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(Svgs.iconPyra, width: 70, height: 70),
            ),
          ),
          GestureDetector(
            onTap: () {
              viewModel.setEvent(Event.eventSkewb);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(Svgs.iconSkewb, width: 70, height: 70),
            ),
          ),
          GestureDetector(
            onTap: () {
              viewModel.setEvent(Event.eventClock);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                Svgs.iconClock,
                width: 70,
                height: 70,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}