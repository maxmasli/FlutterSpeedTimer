import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';
import 'package:speedtimer_fltr/resources/resources.dart';
import 'package:speedtimer_fltr/strings/strings.dart';
import 'package:speedtimer_fltr/ui/navigation/timer_navigation.dart';
import 'package:speedtimer_fltr/ui/screens/dialogs/result_bottom_sheet_widget.dart';
import 'package:speedtimer_fltr/ui/screens/results_screen/result_view_model.dart';
import 'package:speedtimer_fltr/utils/time_format.dart';

class ResultsWidget extends StatelessWidget {
  const ResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(TimerNavigation.timer);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: const [
              _ResultsInfoWidget(),
              _ResultListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => ResultViewModel(),
      child: const ResultsWidget(),
    );
  }
}

class _ResultsInfoWidget extends StatelessWidget {
  const _ResultsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      elevation: 10,
      color: Colors.black,
      child: ColoredBox(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _ResultInfoAvgWidget(),
              Row(
                children: const [
                  _ResultDeleteButtonWidget(),
                  _ResultsInfoEventImage(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultInfoAvgWidget extends StatelessWidget {
  const _ResultInfoAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestResultAvgData =
        context.select((ResultViewModel value) => value.viewModelState.bestResultAvgData);

    final resultAvgData =
        context.select((ResultViewModel value) => value.viewModelState.resultAvgData);

    final bestResult = context.select((ResultViewModel value) => value.viewModelState.best);

    final total = context.select((ResultViewModel value) => value.viewModelState.total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(Strings.currentBest),
        Text(
            "avg 5: ${millisToString(resultAvgData.avg5)} | ${millisToString(bestResultAvgData.avg5)}"),
        Text(
            "avg 12: ${millisToString(resultAvgData.avg12)} | ${millisToString(bestResultAvgData.avg12)}"),
        Text(
            "avg 50: ${millisToString(resultAvgData.avg50)} | ${millisToString(bestResultAvgData.avg50)}"),
        Text(
            "avg 100: ${millisToString(resultAvgData.avg100)} | ${millisToString(bestResultAvgData.avg100)}"),
        Text("best: ${millisToString(bestResult)}"),
        Text("total: $total"),
      ],
    );
  }
}

class _ResultDeleteButtonWidget extends StatelessWidget {
  const _ResultDeleteButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ResultViewModel>();
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              SizedBox(
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => viewModel.deleteResults(),
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

class _ResultsInfoEventImage extends StatelessWidget {
  const _ResultsInfoEventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = context.select((ResultViewModel value) => value.viewModelState.event);
    late String path;
    switch (event) {
      case Event.event2by2:
        {
          path = Svgs.icon2by2;
          break;
        }
      case Event.event3by3:
        {
          path = Svgs.icon3by3;
          break;
        }
      case Event.eventPyra:
        {
          path = Svgs.iconPyra;
          break;
        }
      case Event.eventSkewb:
        {
          path = Svgs.iconSkewb;
          break;
        }
      case Event.eventClock:
        {
          path = Svgs.iconClock;
          break;
        }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SvgPicture.asset(path, width: 70, height: 70),
    );
  }
}

class _ResultListWidget extends StatelessWidget {
  const _ResultListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final results =
        context.select((ResultViewModel value) => value.viewModelState.results).reversed.toList();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: results.length,
          itemBuilder: (BuildContext context, index) {
            return _ResultListItemWidget(results[index]);
          },
        ),
      ),
    );
  }
}

class _ResultListItemWidget extends StatelessWidget {
  final ResultEntity resultEntity;

  const _ResultListItemWidget(this.resultEntity, {Key? key}) : super(key: key);

  void showResultBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      builder: (context) => StatefulBuilder(
        builder: (context, state) {
          return ResultBottomSheetWidget(parentContext: parentContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ResultViewModel>().setResultInBottomSheet(resultEntity);
        showResultBottomSheet(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Center(
          child: Text(millisToString(resultEntity.isDNF ? null : resultEntity.getTime())),
        ),
      ),
    );
  }
}
