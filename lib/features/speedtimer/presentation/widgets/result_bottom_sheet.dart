import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';

class ResultBottomSheet extends StatelessWidget {
  final ResultEntity resultEntity;
  final int index;

  const ResultBottomSheet(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) =>
          prev.resultInBottomSheet != state.resultInBottomSheet,
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResultBodyWidget(
                    resultEntity: resultEntity,
                    index: index,
                  ),
                ),
              ),
              ResultPenaltyButtons(resultEntity: state.resultInBottomSheet!),
            ],
          ),
        );
      },
    );
  }
}

class ResultPenaltyButtons extends StatelessWidget {
  const ResultPenaltyButtons({Key? key, required this.resultEntity})
      : super(key: key);

  final ResultEntity resultEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResultBottomSheetPlus2ButtonWidget(resultEntity: resultEntity),
        ResultBottomSheetDNFButtonWidget(resultEntity: resultEntity),
        ResultBottomSheetDeleteButtonWidget(resultEntity: resultEntity),
      ],
    );
  }
}

class ResultBodyWidget extends StatelessWidget {
  const ResultBodyWidget(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  final ResultEntity resultEntity;
  final int index;

  @override
  Widget build(BuildContext context) {
    final state = context.read<TimerBloc>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SolveTimeWidget(
          time: state.resultInBottomSheet!.stringTime,
          isPlus: state.resultInBottomSheet!.isPlus2,
          isDNF: state.resultInBottomSheet!.isDNF,
        ),
        ScrambleWidget(
          scramble: state.resultInBottomSheet!.scramble,
        ),
        DescriptionWidget(
          resultEntity: resultEntity,
          index: index,
        ),
      ],
    );
  }
}

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  final ResultEntity resultEntity;
  final int index;

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
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
    final bloc = context.read<TimerBloc>();
    return SizedBox(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        controller: _controller,
        minLines: 6,
        maxLines: 6,
        onChanged: (text) {
          bloc.add(TimerUpdateDescriptionEvent(text, widget.index));
        },
      ),
    );
  }
}

class ScrambleWidget extends StatelessWidget {
  const ScrambleWidget({Key? key, required this.scramble}) : super(key: key);

  final String scramble;

  @override
  Widget build(BuildContext context) {
    return Text(
      scramble,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    );
  }
}

class SolveTimeWidget extends StatelessWidget {
  const SolveTimeWidget(
      {Key? key, required this.time, required this.isPlus, required this.isDNF})
      : super(key: key);

  final String time;
  final bool isPlus;
  final bool isDNF;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(time,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
            )),
        const SizedBox(width: 10),
        if (isPlus)
          const Text(
            "+2",
            style: TextStyle(color: Colors.red, fontSize: 24),
          ),
      ],
    );
  }
}

class ResultBottomSheetPlus2ButtonWidget extends StatelessWidget {
  final ResultEntity resultEntity;

  const ResultBottomSheetPlus2ButtonWidget(
      {Key? key, required this.resultEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    var backgroundColor = Colors.white;
    if (resultEntity.isPlus2) {
      backgroundColor = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          bloc.add(TimerPlus2Event(resultEntity));
        },
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 2),
            color: backgroundColor,
          ),
          child: const Text(
            "+2",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ResultBottomSheetDNFButtonWidget extends StatelessWidget {
  final ResultEntity resultEntity;

  const ResultBottomSheetDNFButtonWidget({Key? key, required this.resultEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    var backgroundColor = Colors.transparent;
    if (resultEntity.isDNF) {
      backgroundColor = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          bloc.add(TimerDNFEvent(resultEntity));
        },
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 2),
            color: backgroundColor,
          ),
          child: const Text(
            "DNF",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ResultBottomSheetDeleteButtonWidget extends StatelessWidget {
  final ResultEntity resultEntity;

  final FocusNode _focusNode = FocusNode();

  ResultBottomSheetDeleteButtonWidget(
      {Key? key, required this.resultEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) {
            FocusScope.of(context).unfocus();
          }
          bloc.add(TimerDeleteResultEvent(resultEntity));
          Navigator.of(context).pop();
        },
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 2),
          ),
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
