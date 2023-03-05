import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/core/utils/speedcubing_timer.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/compare_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_scramble_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/save_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/update_last_result_use_case.dart';
import 'package:wakelock/wakelock.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final SaveResultUseCase _saveResultUseCase;
  final GetAllResultsUseCase _getAllResultsUseCase;
  final GetScrambleUseCase _getScrambleUseCase;
  final UpdateResultUseCase _updateResultUseCase;
  final DeleteResultUseCase _deleteResultUseCase;
  final GetAvgUseCase _getAvgUseCase;
  final GetBestAvgUseCase _getBestAvgUseCase;
  final CompareBestAvgUseCase _compareBestAvgUseCase;
  final DeleteAllResultsUseCase _deleteAllResultsUseCase;

  Timer? _timer;
  final _speedcubingTimer = SpeedcubingTimer();

  TimerBloc({
    required SaveResultUseCase saveResultUseCase,
    required GetAllResultsUseCase getAllResultsUseCase,
    required GetScrambleUseCase getScrambleUseCase,
    required UpdateResultUseCase updateLastResultUseCase,
    required DeleteResultUseCase deleteResultUseCase,
    required GetAvgUseCase getAvgUseCase,
    required GetBestAvgUseCase getBestAvgUseCase,
    required CompareBestAvgUseCase compareBestAvgUseCase,
    required DeleteAllResultsUseCase deleteAllResultsUseCase,
  })  : _saveResultUseCase = saveResultUseCase,
        _getAllResultsUseCase = getAllResultsUseCase,
        _getScrambleUseCase = getScrambleUseCase,
        _updateResultUseCase = updateLastResultUseCase,
        _deleteResultUseCase = deleteResultUseCase,
        _getAvgUseCase = getAvgUseCase,
        _getBestAvgUseCase = getBestAvgUseCase,
        _compareBestAvgUseCase = compareBestAvgUseCase,
        _deleteAllResultsUseCase = deleteAllResultsUseCase,
        super(const TimerState(
          event: Event.cube333,
          scramble: "",
          timeInMillis: 0,
          timerStateEnum: TimerStateEnum.stop,
          avgEntity:
              AvgEntity(avg5: null, avg12: null, avg50: null, avg100: null),
          bestAvgEntity:
              AvgEntity(avg5: null, avg12: null, avg50: null, avg100: null),
        )) {
    on<TimerAppStartedEvent>(_appStarted);
    on<TimerOnTapDownEvent>(_timerOnTapDown);
    on<TimerOnTapUpEvent>(_timerOnTapUp);
    on<TimerPressedEvent>(_timerPressed);
    on<TimerReadyEvent>(_timerReady);
    on<TimerStartEvent>(_timerStart);
    on<TimerStopEvent>(_timerStop);
    on<TimerSaveResultEvent>(_saveResult);
    on<TimerGetScrambleEvent>(_getScramble);
    on<TimerGetAllResultsEvent>(_getAllResults);
    on<TimerPlus2Event>(_setPlus2);
    on<TimerDNFEvent>(_setDNF);
    on<TimerDeleteResultEvent>(_deleteResult);
    on<TimerAddResultBottomSheet>(_addResultBottomSheet);
    on<TimerUpdateDescriptionEvent>(_updateDescriptionEvent);
    on<TimerRecountAvgEvent>(_recountAvg);
    on<TimerGetBestAvgEvent>(_getBestAvg);
    on<TimerCompareBestAvgEvent>(_compareBestAvg);
    on<TimerDeleteAllResultsEvent>(_deleteAllResults);
  }

  ///this method calls when starting
  void _appStarted(TimerAppStartedEvent event, Emitter<TimerState> emit) {
    add(TimerGetScrambleEvent());
    add(TimerGetAllResultsEvent());
    //add(TimerRecountAvgEvent());
  }

  ///calls when finger tap down
  void _timerOnTapDown(TimerOnTapDownEvent event, Emitter<TimerState> emit) {
    if (state.timerStateEnum == TimerStateEnum.stop) {
      add(TimerPressedEvent());
    } else if (state.timerStateEnum == TimerStateEnum.running) {
      add(TimerStopEvent());
    }
  }

  ///calls when finger tap up
  void _timerOnTapUp(TimerOnTapUpEvent event, Emitter<TimerState> emit) {
    if (state.timerStateEnum == TimerStateEnum.readyToStart) {
      add(TimerStartEvent());
    }
  }

  ///calls when finger on the screen
  void _timerPressed(TimerPressedEvent event, Emitter<TimerState> emit) {
    emit(state.copyWith(timerStateEnum: TimerStateEnum.pressed));
    add(TimerReadyEvent());
  }

  ///calls then timer is ready
  void _timerReady(TimerReadyEvent event, Emitter<TimerState> emit) {
    emit(state.copyWith(timerStateEnum: TimerStateEnum.readyToStart));
  }

  ///method for start timer
  void _timerStart(TimerStartEvent event, Emitter<TimerState> emit) {
    Wakelock.enable(); // prevent screen from going into sleep mode
    emit(state.copyWith(timerStateEnum: TimerStateEnum.running));
    _startListeningTimer();
  }

  ///method for stop timer
  Future<void> _timerStop(
      TimerStopEvent event, Emitter<TimerState> emit) async {
    Wakelock.disable(); // let screen to sleep
    emit(state.copyWith(timerStateEnum: TimerStateEnum.stop));
    _stopListeningTimer();
    add(const TimerSaveResultEvent(null));
    add(TimerGetScrambleEvent());
  }

  ///this method saves result. If resultEntity in [TimerSaveResultEvent] is null
  ///the current time is taken and the current result is stored after solve
  ///If resultEntity exists in [TimerSaveResultEvent] then resultEntity is stored
  ///after saving, [TimerRecountAvgEvent] and [TimerCompareBestAvgEvent] are called
  Future<void> _saveResult(
      TimerSaveResultEvent event, Emitter<TimerState> emit) async {
    if (event.resultEntity == null) {
      final resultEntity = ResultEntity(
          timeInMillis: state.timeInMillis,
          scramble: state.scramble,
          isPlus2: false,
          isDNF: false,
          event: state.event,
          description: "");
      await _saveResultUseCase(ParamsResult(resultEntity));
      //final results = state.results..add(resultEntity);
      final results = <ResultEntity>[...state.results, resultEntity];
      print("save results");
      emit(state.copyWith(currentResult: resultEntity, results: results));
    } else {
      await _saveResultUseCase(ParamsResult(event.resultEntity!));
      final results = <ResultEntity>[...state.results, event.resultEntity!];
      emit(
          state.copyWith(currentResult: event.resultEntity!, results: results));
    }
    add(TimerRecountAvgEvent());
    add(TimerCompareBestAvgEvent());
  }

  ///the method receives the scramble and writes it to the state
  Future<void> _getScramble(
      TimerGetScrambleEvent event, Emitter<TimerState> emit) async {
    final scramble = _getScrambleUseCase(ParamsEvent(state.event));
    (await scramble).fold(
      (l) => null,
      (r) => emit(state.copyWith(scramble: r)),
    );
  }

  ///This method is called every time the program is started or when the [Event] is changed.
  Future<void> _getAllResults(
      TimerGetAllResultsEvent event, Emitter<TimerState> emit) async {
    print("getAllResults");
    final results = await _getAllResultsUseCase(ParamsEvent(state.event));
    results.fold(
      (l) => null,
      (r) => emit(state.copyWith(results: r)),
    );

    ///after geting all results
    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(false));
  }

  ///this method sets the plus2 flag to true. If index is null or or index equals
  ///the last result index, then the flag is
  ///overwritten in the current result, if not, then the flag is overwritten in
  ///the results list by index
  ///After the operation, [TimerRecountAvgEvent] and [TimerGetBestAvgEvent] are called
  Future<void> _setPlus2(
      TimerPlus2Event event, Emitter<TimerState> emit) async {
    if (event.index == null) {
      // update last/current result
      if (state.currentResult == null) return;
      final penalty = !state.currentResult!.isPlus2;
      final updatedResult = state.currentResult!.copyWith(isPlus2: penalty);
      var updatedTimeInMillis = updatedResult.timeInMillis;
      if (penalty) {
        updatedTimeInMillis += penaltyInMillis;
      }

      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, state.results.length - 1));
      state.results.last = updatedResult;
      emit(state.copyWith(
          currentResult: updatedResult, timeInMillis: updatedTimeInMillis));
    } else {
      // in bottom sheet
      final penalty = !state.resultInBottomSheet!.isPlus2;
      final updatedResult =
          state.resultInBottomSheet!.copyWith(isPlus2: penalty);
      final results = state.results..[event.index!] = updatedResult;
      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, event.index!));

      // if updated last solve (currentResult)
      if (state.results.length - 1 == event.index && state.currentResult != null) {
        var updatedTimeInMillis = updatedResult.timeInMillis;
        if (penalty) {
          updatedTimeInMillis += penaltyInMillis;
        }
        emit(state.copyWith(currentResult: updatedResult, timeInMillis: updatedTimeInMillis));
      }

      emit(
          state.copyWith(resultInBottomSheet: updatedResult, results: results));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
  }

  ///this method sets the dnf flag to true. If index is null or index equals the
  ///last result index, then the flag is
  ///overwritten in the current result, if not, then the flag is overwritten in
  ///the results list by index
  ///After the operation, [TimerRecountAvgEvent] and [TimerGetBestAvgEvent] are called
  Future<void> _setDNF(TimerDNFEvent event, Emitter<TimerState> emit) async {
    if (event.index == null) {
      // update last/current result
      if (state.currentResult == null) return;
      final penalty = !state.currentResult!.isDNF;
      final updatedResult = state.currentResult!.copyWith(isDNF: penalty);
      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, state.results.length - 1));
      state.results.last = updatedResult;
      emit(state.copyWith(currentResult: updatedResult));
    } else {
      // in bottom sheet
      final penalty = !state.resultInBottomSheet!.isDNF;
      final updatedResult = state.resultInBottomSheet!.copyWith(isDNF: penalty);
      final results = state.results..[event.index!] = updatedResult;
      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, event.index!));

      // if updated last solve (currentResult)
      if (state.results.length - 1 == event.index && state.currentResult != null) {
        emit(state.copyWith(currentResult: updatedResult));
      }

      emit(
          state.copyWith(resultInBottomSheet: updatedResult, results: results));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
  }

  ///in this method if index is null or index equals the last result index.
  ///then the last result is deleted, if not,
  ///then the result is deleted by index
  Future<void> _deleteResult(
      TimerDeleteResultEvent event, Emitter<TimerState> emit) async {
    //if index == null or chosen result == currentResult
    if (event.index == null) {
      if (state.currentResult == null) return;
      // deleting current result
      final length = state.results.length;
      await _deleteResultUseCase(ParamsIndexedEvent(state.event, length - 1));
      final results = state.results..removeAt(length - 1);
      emit(state
          .copyWith(results: results, timeInMillis: 0)
          .nullCurrentResult());
    } else {
      //deleting result from bottomSheet
      await _deleteResultUseCase(ParamsIndexedEvent(state.event, event.index!));

      if (state.results.length - 1 == event.index) { // if deleted last solve (currentResult)
        emit(state.copyWith(timeInMillis: 0).nullCurrentResult());
      }

      final results = state.results.toList()
        ..removeAt(event.index!); // copy and remove

      emit(state.copyWith(results: results));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
  }

  ///this method delete all results
  Future<void> _deleteAllResults(
      TimerDeleteAllResultsEvent event, Emitter<TimerState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _deleteAllResultsUseCase(ParamsEvent(state.event));
    emit(state.copyWith(results: [], currentResult: null, timeInMillis: 0));
    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
  }

  ///this method recalculates the average time and writes it to the state
  Future<void> _recountAvg(
      TimerRecountAvgEvent event, Emitter<TimerState> emit) async {
    final avg = await _getAvgUseCase(ParamsListResult(state.results));

    avg.fold(
      (l) => emit(state.copyWith(
          avgEntity: const AvgEntity(
        avg5: null,
        avg12: null,
        avg50: null,
        avg100: null,
      ))),
      (avg) => emit(state.copyWith(avgEntity: avg)),
    );
  }

  ///this method adds the currently selected result to the resultInBottomSheet
  ///field in which the user can interact with it
  void _addResultBottomSheet(
      TimerAddResultBottomSheet event, Emitter<TimerState> emit) {
    emit(state.copyWith(resultInBottomSheet: event.resultEntity));
  }

  ///This method is called when the user changes the description in the BottomSheet
  void _updateDescriptionEvent(
      TimerUpdateDescriptionEvent event, Emitter<TimerState> emit) {
    final updatedResult =
        state.resultInBottomSheet!.copyWith(description: event.text);
    final results = state.results..[event.index] = updatedResult;
    //without await
    _updateResultUseCase(ParamsIndexedResult(updatedResult, event.index));

    emit(state.copyWith(resultInBottomSheet: updatedResult, results: results));
  }

  ///This method takes in a list of results and completely recalculates it if the
  ///forceRecount flag is set or the best average time is not stored in sharedPreferences.
  ///Otherwise it returns the best result stored in sharedPreferences
  void _getBestAvg(TimerGetBestAvgEvent event, Emitter<TimerState> emit) async {
    final bestAvg = await _getBestAvgUseCase(
        ParamsEventList(state.event, state.results, event.forceRecount));
    bestAvg.fold(
      (l) => null,
      (bestAvg) {
        emit(state.copyWith(bestAvgEntity: bestAvg));
        print(bestAvg);
      },
    );
  }

  ///This method compares the current average time and the best average time,
  ///and changes the best average time according to the result.
  Future<void> _compareBestAvg(
      TimerCompareBestAvgEvent event, Emitter<TimerState> emit) async {
    final bestAvg = await _compareBestAvgUseCase(
        ParamsBestAvgs(state.avgEntity, state.bestAvgEntity, state.event));
    bestAvg.fold(
      (l) => null,
      (bestAvg) => emit(state.copyWith(bestAvgEntity: bestAvg)),
    );
  }

  ///This method starts the [SpeedcubingTimer] After 10 milliseconds, the update method is called
  void _startListeningTimer() {
    _speedcubingTimer.startTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _updateTimer();
    });
  }

  ///This method stops the [SpeedcubingTimer]
  void _stopListeningTimer() {
    _speedcubingTimer.stopTimer();
    _timer?.cancel();
  }

  ///This method updates the current time state every 10 milliseconds
  void _updateTimer() {
    emit(state.copyWith(timeInMillis: _speedcubingTimer.getTime()));
  }
}
