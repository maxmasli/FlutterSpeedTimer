import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/resources/strings.dart';
import 'package:speedtimer_fltr/ui/screens/timer_screen/timer_view_model.dart';
import 'package:speedtimer_fltr/utils/functions.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: const [
              _TimerEditWidget(),
              _TimerBodyWidget(),
              _PenaltyButtonsWidget(),
              _TimerSERButtonsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => TimerViewModel(),
      child: const TimerWidget(),
    );
  }
}

class _TimerBodyWidget extends StatelessWidget {
  const _TimerBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    return Expanded(
      child: Stack(
        children: [
          Column(
            children: const [
              SizedBox(height: 5),
              _TimerTimeWidget(),
              SizedBox(height: 5),
              _TimerScrambleWidget(),
              SizedBox(height: 10),
              _TimerResultsWidget(),
            ],
          ),
          GestureDetector(
            onTapDown: (_) => viewModel.onTapDown(),
            onTapUp: (_) => viewModel.onTapUp(),
          ),
        ],
      ),
    );
  }
}

class _PenaltyButtonsWidget extends StatelessWidget {
  const _PenaltyButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _DNFButtonWidget(),
        SizedBox(width: 15),
        _PlusButtonWidget(),
        SizedBox(width: 15),
        _DeleteButtonWidget(),
      ],
    );
  }
}

class _DeleteButtonWidget extends StatelessWidget {
  const _DeleteButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    return TextButton(
      onPressed: () => viewModel.deleteResult(),
      child: Text(
        Strings.delete,
        style: Theme.of(context).textTheme.bodyText1
      ),
    );
  }
}

class _DNFButtonWidget extends StatelessWidget {
  const _DNFButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    //final currentResult = context.select((TimerViewModel value) => value.viewModelState.currentResult);
    final currentResult = context.watch<TimerViewModel>().viewModelState.currentResult;
    late Color backgroundColor;

    if (currentResult == null) {
      backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    } else if (currentResult.isDNF) {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    }

    return TextButton(
      onPressed: () => viewModel.setDNF(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Text(
        Strings.DNF,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  }
}

class _PlusButtonWidget extends StatelessWidget {
  const _PlusButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    final currentResult = context.watch<TimerViewModel>().viewModelState.currentResult;
    late Color backgroundColor;

    if (currentResult == null) {
      backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    } else if (currentResult.isPlus) {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    }

    return TextButton(
      onPressed: () => viewModel.setPlus(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Text(
        Strings.plus2,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  }
}

class _TimerEditWidget extends StatelessWidget {
  const _TimerEditWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Expanded(
          child: ElevatedButton(
            onPressed: null,
            child: Text(Strings.writeYourScramble),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: null,
            child: Text(Strings.writeTime),
          ),
        ),
      ],
    );
  }
}

class _TimerTimeWidget extends StatelessWidget {
  const _TimerTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select((TimerViewModel value) => value.viewModelState.state);
    final time = context.select((TimerViewModel value) => value.viewModelState.time);

    final color = state == TimerState.readyToStart
        ? Colors.green
        : Theme.of(context).textTheme.bodyText1!.color;

    return Text(
      millisToString(time),
      style: TextStyle(fontSize: 70, color: color),
    );
  }
}

class _TimerScrambleWidget extends StatelessWidget {
  const _TimerScrambleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scramble = context.select((TimerViewModel value) => value.viewModelState.scramble);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          scramble,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TimerResultsWidget extends StatelessWidget {
  const _TimerResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestResultAvgData =
        context.select((TimerViewModel value) => value.viewModelState.bestResultAvgData);

    final resultAvgData =
        context.select((TimerViewModel value) => value.viewModelState.resultAvgData);

    final bestResult = context.select((TimerViewModel value) => value.viewModelState.best);

    final total = context.select((TimerViewModel value) => value.viewModelState.total);

    const textStyle = TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Strings.currentBest,
              style: textStyle,
            ),
            Text(
              "avg 5: ${millisToString(resultAvgData.avg5)} | ${millisToString(bestResultAvgData.avg5)}",
              style: textStyle,
            ),
            Text(
              "avg 12: ${millisToString(resultAvgData.avg12)} | ${millisToString(bestResultAvgData.avg12)}",
              style: textStyle,
            ),
            Text(
              "avg 50: ${millisToString(resultAvgData.avg50)} | ${millisToString(bestResultAvgData.avg50)}",
              style: textStyle,
            ),
            Text(
              "avg 100: ${millisToString(resultAvgData.avg100)} | ${millisToString(bestResultAvgData.avg100)}",
              style: textStyle,
            ),
            Text(
              "best: ${millisToString(bestResult)}",
              style: textStyle,
            ),
            Text(
              "total: ${total.toString()}",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// SER - Settings Event Results :)
class _TimerSERButtonsWidget extends StatelessWidget {
  const _TimerSERButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _TimerSettingsButtonWidget(),
        SizedBox(width: 10),
        _TimerEventButtonWidget(),
        SizedBox(width: 10),
        _TimerResultsButtonWidget(),
      ],
    );
  }
}

class _TimerSettingsButtonWidget extends StatelessWidget {
  const _TimerSettingsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    return SizedBox(
      width: 70,
      child: ElevatedButton(
        onPressed: () => viewModel.navigateToSettings(context),
        child: Icon(Icons.settings, color: Theme.of(context).textTheme.bodyText1!.color,),
      ),
    );
  }
}

class _TimerEventButtonWidget extends StatelessWidget {
  const _TimerEventButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    return Expanded(
      child: ElevatedButton(
        onPressed: () => viewModel.showEventDialog(context),
        child: Text(Strings.event, style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),),
      ),
    );
  }
}

class _TimerResultsButtonWidget extends StatelessWidget {
  const _TimerResultsButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TimerViewModel>();

    return SizedBox(
      width: 70,
      child: ElevatedButton(
        onPressed: () => viewModel.navigateToResults(context),
        // navigate to results
        child: Icon(Icons.wysiwyg, color: Theme.of(context).textTheme.bodyText1!.color,),
      ),
    );
  }
}
