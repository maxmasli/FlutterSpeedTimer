import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/ui/screens/results_screen/result_view_model.dart';

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
    //final result = parentContext.select((ResultViewModel value) => value.viewModelState.resultInBottomSheet);
    final viewModel = widget.parentContext.read<ResultViewModel>();

    return Container(
      child: Column(
        children: [
          Text("${result!.getTime()}"),
          Text("dnf = ${result.isDNF}"),
          ElevatedButton(
            onPressed: () {
              viewModel.setDNFFromBottomSheet();
              setState(() {});
            },
            child: Text("DNF"),
          ),

          ElevatedButton(
            onPressed: () {
              viewModel.deleteResultFromBottomSheet();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
