import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';
import 'package:speedtimer_fltr/resources/strings.dart';
import 'package:speedtimer_fltr/ui/screens/results_screen/result_view_model.dart';
import 'package:speedtimer_fltr/utils/functions.dart';

class ResultBottomSheetWidget extends StatefulWidget {
  const ResultBottomSheetWidget({Key? key, required this.parentContext}) : super(key: key);

  final BuildContext parentContext;

  @override
  State<ResultBottomSheetWidget> createState() => _ResultBottomSheetWidgetState();
}

class _ResultBottomSheetWidgetState extends State<ResultBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final result = widget.parentContext.watch<ResultViewModel>().viewModelState.resultInBottomSheet;
    final viewModel = widget.parentContext.read<ResultViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ResultBottomSheetTimeWidget(result: result!),
          const SizedBox(height: 10),
          _ResultBottomSheetScrambleWidget(result: result),
          const SizedBox(height: 10),
          _ResultBottomSheetDescriptionWidget(result: result, viewModel: viewModel),
          const SizedBox(height: 10),
          _ResultBottomSheetDeleteButton(viewModel: viewModel),
          const SizedBox(height: 40),
        ],
      ),
    );

    // return Container(
    //   child: Column(
    //     children: [
    //       Text("${result!.getTime()}"),
    //       Text("dnf = ${result.isDNF}"),
    //       ElevatedButton(
    //         onPressed: () {
    //           viewModel.setDNFFromBottomSheet();
    //           setState(() {});
    //         },
    //         child: Text("DNF"),
    //       ),
    //
    //       ElevatedButton(
    //         onPressed: () {
    //           viewModel.deleteResultFromBottomSheet();
    //           Navigator.pop(context);
    //         },
    //         child: Text("Delete"),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class _ResultBottomSheetTimeWidget extends StatelessWidget {
  const _ResultBottomSheetTimeWidget({Key? key, required this.result}) : super(key: key);

  final ResultEntity result;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          millisToString(result.getTime()),
          style: const TextStyle(fontSize: 30),
        ),
        if (result.isDNF) const _ResultBottomSheetDNFTextWidget(),
        if (result.isPlus) const _ResultBottomSheetPlusTextWidget(),
      ],
    );
  }
}

class _ResultBottomSheetDNFTextWidget extends StatelessWidget {
  const _ResultBottomSheetDNFTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(width: 10),
        Text(
          Strings.DNF,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _ResultBottomSheetPlusTextWidget extends StatelessWidget {
  const _ResultBottomSheetPlusTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(width: 10),
        Text(
          Strings.plus2,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _ResultBottomSheetScrambleWidget extends StatelessWidget {
  const _ResultBottomSheetScrambleWidget({Key? key, required this.result}) : super(key: key);

  final ResultEntity result;

  @override
  Widget build(BuildContext context) {
    return Text(
      result.scramble,
      style: const TextStyle(fontSize: 20),
    );
  }
}

class _ResultBottomSheetDescriptionWidget extends StatefulWidget {
  const _ResultBottomSheetDescriptionWidget(
      {Key? key, required this.result, required this.viewModel})
      : super(key: key);

  final ResultEntity result;
  final ResultViewModel viewModel;

  @override
  State<_ResultBottomSheetDescriptionWidget> createState() =>
      _ResultBottomSheetDescriptionWidgetState();
}

class _ResultBottomSheetDescriptionWidgetState extends State<_ResultBottomSheetDescriptionWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.result.description;
    _controller.selection =
        TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (text) {
        widget.viewModel.updateDescriptionFromBottomSheet(text);
      },
      style: const TextStyle(fontSize: 17, height: 1),
      minLines: 2,
      maxLines: 2,
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class _ResultBottomSheetDeleteButton extends StatelessWidget {
  const _ResultBottomSheetDeleteButton({Key? key, required this.viewModel}) : super(key: key);

  final ResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  )),
              SizedBox(
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        viewModel.deleteResultFromBottomSheet();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
