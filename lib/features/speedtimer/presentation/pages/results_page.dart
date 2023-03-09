import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/result_bottom_sheet.dart';
import 'package:speedtimer_flutter/resources/resources.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: const [
          ResultsAppBarWidget(),
          ResultsWidget(),
        ],
      ),
    );
  }
}

class ResultsAppBarWidget extends StatelessWidget {
  const ResultsAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.black,
      elevation: 10,
      child: SizedBox(
        height: 130,
        width: double.infinity,
        child: ColoredBox(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              const ResultsAvgWidget(),
              const ResultsBestAvgWidget(),
              const ResultsDeleteAllButtonWidget(),
              const ResultEventImageWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsAvgWidget extends StatelessWidget {
  const ResultsAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.avgEntity != state.avgEntity,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ao5: ${state.avgEntity.stringAvg5}"),
            Text("Ao12: ${state.avgEntity.stringAvg12}"),
            Text("Ao50: ${state.avgEntity.stringAvg50}"),
            Text("Ao100: ${state.avgEntity.stringAvg100}"),
          ],
        );
      },
    );
  }
}

class ResultsBestAvgWidget extends StatelessWidget {
  const ResultsBestAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.bestAvgEntity != state.bestAvgEntity,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Best Ao5: ${state.bestAvgEntity.stringAvg5}"),
            Text("Best Ao12: ${state.bestAvgEntity.stringAvg12}"),
            Text("Best Ao50: ${state.bestAvgEntity.stringAvg50}"),
            Text("Best Ao100: ${state.bestAvgEntity.stringAvg100}"),
          ],
        );
      },
    );
    ;
  }
}

class ResultsDeleteAllButtonWidget extends StatelessWidget {
  const ResultsDeleteAllButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerBloc>().add(TimerDeleteAllResultsEvent());
      },
      child: const Text("delete"),
    );
  }
}

class ResultEventImageWidget extends StatelessWidget {
  const ResultEventImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.event != state.event,
      builder: (context, state) {
        return SvgPicture.asset(
          getSvgAssetByEvent(state.event),
          width: 50,
          height: 50,
        );
      },
    );
  }
}

class ResultsWidget extends StatelessWidget {
  const ResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerBloc, TimerState>(
      listener: (context, state) => print("listen"),
      buildWhen: (prev, state) =>
          prev.results.length != state.results.length ||
          prev.resultInBottomSheet != state.resultInBottomSheet ||
          prev.isLoading != state.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        } else {
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: state.results.length,
              itemBuilder: (BuildContext context, int index) {
                return ResultsItemWidget(
                  resultEntity: state.results.reversed.toList()[index],
                  index: state.results.length - index - 1,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class ResultsItemWidget extends StatelessWidget {
  final ResultEntity resultEntity;
  final int index;

  const ResultsItemWidget(
      {Key? key, required this.resultEntity, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    return GestureDetector(
      onTap: () {
        bloc.add(TimerAddResultBottomSheet(resultEntity));
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          isScrollControlled: true,
          context: context,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<TimerBloc>(context),
            child: ResultBottomSheet(
              resultEntity: resultEntity,
              index: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Center(
              child: Text(
                resultEntity.stringTime,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            if (resultEntity.isPlus2)
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "+2",
                  style: TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
      ),
    );
  }
}
