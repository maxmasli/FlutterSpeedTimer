import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';

class ResultBottomSheet extends StatefulWidget {
  final ResultEntity resultEntity;
  final int index;

  const ResultBottomSheet(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  @override
  State<ResultBottomSheet> createState() => _ResultBottomSheetState();
}

class _ResultBottomSheetState extends State<ResultBottomSheet> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.resultEntity.description;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) =>
          prev.resultInBottomSheet != state.resultInBottomSheet,
      builder: (context, state) {
        final bloc = context.read<TimerBloc>();
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.resultInBottomSheet!.stringTime),
              if (state.resultInBottomSheet!.isDNF)
                const Text("DNF", style: TextStyle(color: Colors.red))
              else if (state.resultInBottomSheet!.isPlus2)
                const Text("+2", style: TextStyle(color: Colors.red)),
              Row(
                children: [
                  ResultBottomSheetPlus2ButtonWidget(
                    resultEntity: state.resultInBottomSheet!,
                    index: widget.index,
                  ),
                  ResultBottomSheetDNFButtonWidget(
                    resultEntity: state.resultInBottomSheet!,
                    index: widget.index,
                  ),
                  ResultBottomSheetDeleteButtonWidget(
                    index: widget.index,
                  ),
                ],
              ),
              Text(state.resultInBottomSheet!.scramble),
              TextField(
                controller: _controller,
                minLines: 2,
                maxLines: 2,
                onChanged: (text) {
                  bloc.add(TimerUpdateDescriptionEvent(text, widget.index));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResultBottomSheetPlus2ButtonWidget extends StatelessWidget {
  final ResultEntity resultEntity;
  final int index;

  const ResultBottomSheetPlus2ButtonWidget(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    var backgroundColor = Colors.transparent;
    if (resultEntity.isPlus2) {
      backgroundColor = Colors.red;
    }
    return ElevatedButton(
      onPressed: () {
        bloc.add(TimerPlus2Event(index));
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
  }
}

class ResultBottomSheetDNFButtonWidget extends StatelessWidget {
  final ResultEntity resultEntity;
  final int index;

  const ResultBottomSheetDNFButtonWidget(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    var backgroundColor = Colors.transparent;
    if (resultEntity.isDNF) {
      backgroundColor = Colors.red;
    }
    return ElevatedButton(
      onPressed: () {
        bloc.add(TimerDNFEvent(index));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(width: 3, color: Colors.black),
        )),
      ),
      child: const Text("DNF", style: TextStyle(color: Colors.black)),
    );
  }
}

class ResultBottomSheetDeleteButtonWidget extends StatelessWidget {
  const ResultBottomSheetDeleteButtonWidget({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return IconButton(
        onPressed: () {
          bloc.add(TimerDeleteResultEvent(index));
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.delete,
        ));
  }
}
