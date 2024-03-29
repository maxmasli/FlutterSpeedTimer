part of 'timer_bloc.dart';

enum TimerStateEnum { stop, running, readyToStart, pressed }

class TimerState extends Equatable {
  final ResultEntity? currentResult;
  final ResultEntity? resultInBottomSheet;
  final List<ResultEntity> results;
  final Event event;
  final String scramble;
  final int timeInMillis;
  final TimerStateEnum timerStateEnum;
  final AvgEntity avgEntity;
  final AvgEntity bestAvgEntity;
  final bool isLoading;
  final SettingsEntity settingsEntity;
  final ResultEntity? bestSolve;

  const TimerState(
      {this.currentResult,
      this.resultInBottomSheet,
      this.results = const <ResultEntity>[],
      required this.timerStateEnum,
      required this.event,
      required this.scramble,
      required this.timeInMillis,
      required this.avgEntity,
      required this.bestAvgEntity,
      required this.settingsEntity,
      required this.bestSolve,
      this.isLoading = false});

  TimerState copyWith({
    ResultEntity? currentResult,
    ResultEntity? resultInBottomSheet,
    List<ResultEntity>? results,
    Event? event,
    String? scramble,
    int? timeInMillis,
    TimerStateEnum? timerStateEnum,
    AvgEntity? avgEntity,
    AvgEntity? bestAvgEntity,
    SettingsEntity? settingsEntity,
    ResultEntity? bestSolve,
    bool? isLoading = false,
  }) {
    return TimerState(
      currentResult: currentResult ?? this.currentResult,
      resultInBottomSheet: resultInBottomSheet ?? this.resultInBottomSheet,
      results: results ?? this.results,
      event: event ?? this.event,
      scramble: scramble ?? this.scramble,
      timeInMillis: timeInMillis ?? this.timeInMillis,
      timerStateEnum: timerStateEnum ?? this.timerStateEnum,
      avgEntity: avgEntity ?? this.avgEntity,
      bestAvgEntity: bestAvgEntity ?? this.bestAvgEntity,
      settingsEntity: settingsEntity ?? this.settingsEntity,
      bestSolve: bestSolve ?? this.bestSolve,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  TimerState nullCurrentResult() {
    return TimerState(
      currentResult: null,
      resultInBottomSheet: resultInBottomSheet,
      results: results,
      event: event,
      scramble: scramble,
      timeInMillis: timeInMillis,
      timerStateEnum: timerStateEnum,
      avgEntity: avgEntity,
      bestAvgEntity: bestAvgEntity,
      settingsEntity: settingsEntity,
      bestSolve: bestSolve,
      isLoading: isLoading,
    );
  }

  TimerState nullBestSolve() {
    return TimerState(
      currentResult: currentResult,
      resultInBottomSheet: resultInBottomSheet,
      results: results,
      event: event,
      scramble: scramble,
      timeInMillis: timeInMillis,
      timerStateEnum: timerStateEnum,
      avgEntity: avgEntity,
      bestAvgEntity: bestAvgEntity,
      settingsEntity: settingsEntity,
      bestSolve: null,
      isLoading: isLoading,
    );
  }

  @override
  List<Object?> get props => [
        currentResult,
        results,
        event,
        scramble,
        timeInMillis,
        timerStateEnum,
        resultInBottomSheet,
        avgEntity,
        bestAvgEntity,
        settingsEntity,
        isLoading,
        bestSolve,
      ];
}
