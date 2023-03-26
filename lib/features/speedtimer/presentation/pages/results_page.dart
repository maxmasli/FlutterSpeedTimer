import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:speedtimer_flutter/di.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/widgets/result_bottom_sheet.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sl<PageController>().animateToPage(1,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: const [
            ResultsAppBarWidget(),
            ResultsWidget(),
            BottomBarWidget(),
          ],
        ),
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
        height: 60,
        width: double.infinity,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: const [
                NavigationBackButtonWidget(),
                EventNameWidget(),
                Expanded(child: SizedBox()),
                // to make space between event and button
                ResultsDeleteAllButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.black,
      elevation: 10,
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          children: const [
            ResultsAvgWidget(),
            ResultsBestAvgWidget(),
          ],
        ),
      ),
    );
  }
}

class EventNameWidget extends StatelessWidget {
  const EventNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Text(
          state.event.toEventString(),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 26,
          ),
        );
      },
    );
  }
}

class NavigationBackButtonWidget extends StatelessWidget {
  const NavigationBackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        sl<PageController>().animateToPage(1,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }
}

class ResultsAvgWidget extends StatelessWidget {
  const ResultsAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: 20, color: Theme.of(context).textTheme.bodyMedium!.color);
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.avgEntity != state.avgEntity,
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ao5: ${state.avgEntity.stringAvg5}", style: style),
                Text("Ao12: ${state.avgEntity.stringAvg12}", style: style),
                Text("Ao50: ${state.avgEntity.stringAvg50}", style: style),
                Text("Ao100: ${state.avgEntity.stringAvg100}", style: style),
                Text("Total: ${state.results.length}", style: style),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ResultsBestAvgWidget extends StatelessWidget {
  const ResultsBestAvgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: 20, color: Theme.of(context).textTheme.bodyMedium!.color);
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.bestAvgEntity != state.bestAvgEntity,
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Best Ao5: ${state.bestAvgEntity.stringAvg5}",
                    style: style),
                Text("Best Ao12: ${state.bestAvgEntity.stringAvg12}",
                    style: style),
                Text("Best Ao50: ${state.bestAvgEntity.stringAvg50}",
                    style: style),
                Text("Best Ao100: ${state.bestAvgEntity.stringAvg100}",
                    style: style),
                Text("Best solve: ${state.bestSolve?.stringTime ?? "DNF"}",
                    style: style)
              ],
            ),
          ),
        );
      },
    );
  }
}

class ResultsDeleteAllButtonWidget extends StatelessWidget {
  const ResultsDeleteAllButtonWidget({Key? key}) : super(key: key);

//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TimerBloc>().add(TimerDeleteAllResultsEvent());
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          "Delete",
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
      ),
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
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) =>
          prev.results.length != state.results.length ||
          prev.resultInBottomSheet != state.resultInBottomSheet ||
          prev.isLoading != state.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Expanded(child: CircularProgressIndicator());
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
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
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
                style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).textTheme.bodyMedium!.color!),
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
