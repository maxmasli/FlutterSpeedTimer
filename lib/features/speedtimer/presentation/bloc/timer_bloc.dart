import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/core/utils/speedcubing_timer.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/settings_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/compare_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_best_sovle_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_delay_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_scramble_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/save_delay_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/save_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/update_result_use_case.dart';
import 'package:uuid/uuid.dart';
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
  final GetBestSolveUseCase _getBestSolveUseCase;
  final SaveDelayUseCase _saveDelayUseCase;
  final GetDelayUseCase _getDelayUseCase;

  Timer? _timer;
  final _speedcubingTimer = SpeedcubingTimer();
  Timer? _delayTimer;

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
    required GetBestSolveUseCase getBestSolveUseCase,
    required SaveDelayUseCase saveDelayUseCase,
    required GetDelayUseCase getDelayUseCase,
  })  : _saveResultUseCase = saveResultUseCase,
        _getAllResultsUseCase = getAllResultsUseCase,
        _getScrambleUseCase = getScrambleUseCase,
        _updateResultUseCase = updateLastResultUseCase,
        _deleteResultUseCase = deleteResultUseCase,
        _getAvgUseCase = getAvgUseCase,
        _getBestAvgUseCase = getBestAvgUseCase,
        _compareBestAvgUseCase = compareBestAvgUseCase,
        _deleteAllResultsUseCase = deleteAllResultsUseCase,
        _getBestSolveUseCase = getBestSolveUseCase,
        _saveDelayUseCase = saveDelayUseCase,
        _getDelayUseCase = getDelayUseCase,
        super(const TimerState(
          event: Event.cube333,
          scramble: "",
          timeInMillis: 0,
          timerStateEnum: TimerStateEnum.stop,
          avgEntity:
              AvgEntity(avg5: null, avg12: null, avg50: null, avg100: null),
          bestAvgEntity:
              AvgEntity(avg5: null, avg12: null, avg50: null, avg100: null),
          settingsEntity: SettingsEntity(delay: 0),
          bestSolve: null,
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
    on<TimerGetAllResultsAndRecalculateEvent>(_getAllResultsAndRecalculate);
    on<TimerPlus2Event>(_setPlus2);
    on<TimerDNFEvent>(_setDNF);
    on<TimerDeleteResultEvent>(_deleteResult);
    on<TimerAddResultBottomSheet>(_addResultBottomSheet);
    on<TimerUpdateDescriptionEvent>(_updateDescriptionEvent);
    on<TimerRecountAvgEvent>(_recountAvg);
    on<TimerGetBestAvgEvent>(_getBestAvg);
    on<TimerCompareBestAvgEvent>(_compareBestAvg);
    on<TimerDeleteAllResultsEvent>(_deleteAllResults);
    on<TimerChangeEvent>(_changeEvent);
    on<TimerSetDelayEvent>(_setDelay);
    on<TimerGetDelayEvent>(_getDelay);
    on<TimerGetBestSolveEvent>(_getBestSolve);
  }

  ///this method calls when starting
  void _appStarted(TimerAppStartedEvent event, Emitter<TimerState> emit) {
    add(TimerGetScrambleEvent());
    add(TimerGetAllResultsAndRecalculateEvent());
    add(TimerGetDelayEvent());
  }

  ///calls when finger tap down
  void _timerOnTapDown(TimerOnTapDownEvent event, Emitter<TimerState> emit) {
    print(state.timerStateEnum);
    if (state.timerStateEnum == TimerStateEnum.stop) {
      add(TimerPressedEvent());
    } else if (state.timerStateEnum == TimerStateEnum.running) {
      add(TimerStopEvent());
    }
  }

  ///calls when finger tap up
  ///when _delayTimer != null _delayTimer will cancel. It means if your delay in
  ///[SettingsEntity] != 0 and you put finger and remove from screen, but delay
  ///time is not finish, the _delayTimer are destroyed and solve are not counting
  void _timerOnTapUp(TimerOnTapUpEvent event, Emitter<TimerState> emit) {
    print(state.timerStateEnum);
    if (state.timerStateEnum == TimerStateEnum.readyToStart) {
      add(TimerStartEvent());
    } else {
      if (_delayTimer != null) {
        _delayTimer!.cancel();
        _delayTimer == null;
        emit(state.copyWith(timerStateEnum: TimerStateEnum.stop));
      }
    }
  }

  ///calls when finger on the screen
  ///when state.settingsEntity.delay != 0 the _delayTimer is calling
  void _timerPressed(TimerPressedEvent event, Emitter<TimerState> emit) {
    emit(state.copyWith(timerStateEnum: TimerStateEnum.pressed));
    if (state.settingsEntity.delay != 0) {
      _delayTimer = Timer(
          Duration(milliseconds: (state.settingsEntity.delay * 1000).toInt()),
          () {
        add(TimerReadyEvent());
      });
    } else {
      add(TimerReadyEvent());
    }
  }

  ///calls then timer is ready
  void _timerReady(TimerReadyEvent event, Emitter<TimerState> emit) {
    if (state.timerStateEnum == TimerStateEnum.pressed) {
      emit(state.copyWith(timerStateEnum: TimerStateEnum.readyToStart));
    }
  }

  ///method for start timer
  Future<void> _timerStart(
      TimerStartEvent event, Emitter<TimerState> emit) async {
    emit(state.copyWith(timerStateEnum: TimerStateEnum.running));
    _startListeningTimer();
    await Wakelock.enable(); // prevent screen from going into sleep mode
  }

  ///method for stop timer
  Future<void> _timerStop(
      TimerStopEvent event, Emitter<TimerState> emit) async {
    emit(state.copyWith(timerStateEnum: TimerStateEnum.stop));
    _stopListeningTimer();
    add(const TimerSaveResultEvent(null));
    add(TimerGetScrambleEvent());
    await Wakelock.disable(); // let screen to sleep
  }

  ///this method saves result. If resultEntity in [TimerSaveResultEvent] is null
  ///the current time is taken and the current result is stored after solve
  ///If resultEntity exists in [TimerSaveResultEvent] then resultEntity is stored
  ///after saving, [TimerRecountAvgEvent] and [TimerCompareBestAvgEvent] are called
  Future<void> _saveResult(
      TimerSaveResultEvent event, Emitter<TimerState> emit) async {
    if (event.resultEntity == null) {
      final resultEntity = ResultEntity(
          uuid: const Uuid().v4(),
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
    add(TimerGetBestSolveEvent());
  }

  ///the method receives the scramble and writes it to the state
  Future<void> _getScramble(
      TimerGetScrambleEvent event, Emitter<TimerState> emit) async {
    final scramble = await _getScrambleUseCase(ParamsEvent(state.event));
    scramble.fold(
      (l) => null,
      (r) => emit(state.copyWith(scramble: r)),
    );
  }

  ///This method is called every time the program is started or when the [Event] is changed.
  Future<void> _getAllResultsAndRecalculate(
      TimerGetAllResultsAndRecalculateEvent event,
      Emitter<TimerState> emit) async {
    print("getAllResults");
    final results = await _getAllResultsUseCase(ParamsEvent(state.event));
    results.fold(
      (l) => null,
      (r) => emit(state.copyWith(results: r)),
    );

    ///after getting all results
    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(false));
    add(TimerGetBestSolveEvent());
  }

  ///this method sets the plus2 flag to true. If resultEntity is null then the flag is
  ///overwritten in the current result, if not, then the flag is overwritten in
  ///the results list
  ///After the operation, [TimerRecountAvgEvent] and [TimerGetBestAvgEvent] are called
  Future<void> _setPlus2(
      TimerPlus2Event event, Emitter<TimerState> emit) async {
    if (event.resultEntity == null) {
      //updating last/current result
      if (state.currentResult == null) return;
      final penalty = !state.currentResult!.isPlus2;
      final updatedResult = state.currentResult!.copyWith(isPlus2: penalty);
      var updatedTimeInMillis = updatedResult.timeInMillis;
      if (penalty) {
        updatedTimeInMillis += penaltyInMillis;
      }
      state.results.last = updatedResult;
      emit(state.copyWith(
          currentResult: updatedResult, timeInMillis: updatedTimeInMillis));

      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, state.results.length - 1));
    } else {
      final penalty = !event.resultEntity!.isPlus2;
      final updatedResult = event.resultEntity!.copyWith(isPlus2: penalty);
      final index = state.results.toList().indexOf(event.resultEntity!);
      final updatedResultsList = state.results.toList()
        ..[index] = updatedResult;

      if (state.results.length - 1 == index) {
        //updated last result
        var updatedTimeInMillis = updatedResult.timeInMillis;
        if (penalty) {
          updatedTimeInMillis += penaltyInMillis;
        }
        emit(state.copyWith(
            currentResult: updatedResult, timeInMillis: updatedTimeInMillis));
      }

      emit(state.copyWith(
        results: updatedResultsList,
        resultInBottomSheet: updatedResult,
      ));

      await _updateResultUseCase(ParamsIndexedResult(updatedResult));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
    add(TimerGetBestSolveEvent());
  }

  ///this method sets the dnf flag to true. If resultEntity is null then the flag is
  ///overwritten in the current result, if not, then the flag is overwritten in
  ///the results list
  ///After the operation, [TimerRecountAvgEvent] and [TimerGetBestAvgEvent] are called
  Future<void> _setDNF(TimerDNFEvent event, Emitter<TimerState> emit) async {
    if (event.resultEntity == null) {
      //updating last/current result
      if (state.currentResult == null) return;
      final penalty = !state.currentResult!.isDNF;
      final updatedResult = state.currentResult!.copyWith(isDNF: penalty);
      state.results.last = updatedResult;
      emit(state.copyWith(currentResult: updatedResult));

      await _updateResultUseCase(
          ParamsIndexedResult(updatedResult, state.results.length - 1));
    } else {
      final penalty = !event.resultEntity!.isDNF;
      final updatedResult = event.resultEntity!.copyWith(isDNF: penalty);
      final index = state.results.toList().indexOf(event.resultEntity!);
      final updatedResultsList = state.results.toList()
        ..[index] = updatedResult;
      if (state.results.length - 1 == index) {
        //updated last result
        emit(state.copyWith(currentResult: updatedResult));
      }
      emit(state.copyWith(
        results: updatedResultsList,
        resultInBottomSheet: updatedResult,
      ));

      await _updateResultUseCase(ParamsIndexedResult(updatedResult));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
    add(TimerGetBestSolveEvent());
  }

  ///in this method if resultEntity is null
  ///then the last result is deleted, if not,
  ///then the resultEntity is deleted
  //////After the operation, [TimerRecountAvgEvent] and [TimerGetBestAvgEvent] are called
  Future<void> _deleteResult(
      TimerDeleteResultEvent event, Emitter<TimerState> emit) async {
    //if delete current solve
    if (event.resultEntity == null) {
      if (state.currentResult == null) return;
      final resultToDelete = state.currentResult!;
      final results = state.results.toList()
        ..removeAt(state.results.length - 1);

      await _deleteResultUseCase(
          ParamsIndexedResult(resultToDelete, state.results.length - 1));

      emit(state
          .copyWith(results: results, timeInMillis: 0)
          .nullCurrentResult());
    } else {
      final index = state.results.toList().indexOf(event.resultEntity!);
      if (state.results.length - 1 == index) {
        // if deleted last solve (currentResult)
        emit(state.copyWith(timeInMillis: 0).nullCurrentResult());
      }
      final results = state.results.toList()
        ..removeAt(index); // copy and remove

      emit(state.copyWith(results: results));
      await _deleteResultUseCase(ParamsIndexedResult(event.resultEntity!));
    }

    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
    add(TimerGetBestSolveEvent());
  }

  ///this method delete all results
  Future<void> _deleteAllResults(
      TimerDeleteAllResultsEvent event, Emitter<TimerState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _deleteAllResultsUseCase(ParamsEvent(state.event));
    emit(state.copyWith(results: [], currentResult: null, timeInMillis: 0));
    add(TimerRecountAvgEvent());
    add(const TimerGetBestAvgEvent(true));
    add(TimerGetBestSolveEvent());
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
      TimerUpdateDescriptionEvent event, Emitter<TimerState> emit) async {
    final updatedResult =
        state.resultInBottomSheet!.copyWith(description: event.text);
    final results = state.results..[event.index] = updatedResult;
    await _updateResultUseCase(ParamsIndexedResult(updatedResult, event.index));

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

  ///This method get best solve
  void _getBestSolve(
      TimerGetBestSolveEvent event, Emitter<TimerState> emit) async {
    final bestSolve =
        await _getBestSolveUseCase(ParamsListResult(state.results));
    bestSolve.fold(
      (l) => null,
      (bestSolve) {
        if (bestSolve == null) {
          emit(state.nullBestSolve());
        } else {
          emit(state.copyWith(bestSolve: bestSolve));
        }
      },
    );
  }

  ///This method changes event
  Future<void> _changeEvent(
      TimerChangeEvent event, Emitter<TimerState> emit) async {
    emit(state
        .copyWith(event: event.event, timeInMillis: 0)
        .nullCurrentResult());
    add(TimerGetScrambleEvent());
    add(TimerGetAllResultsAndRecalculateEvent());
  }

  ///this method set delay
  Future<void> _setDelay(
      TimerSetDelayEvent event, Emitter<TimerState> emit) async {
    print("set delay ${event.delay}");
    emit(
      state.copyWith(
        settingsEntity: state.settingsEntity.copyWith(delay: event.delay),
      ),
    );

    await _saveDelayUseCase(ParamsDelay(event.delay));
  }

  ///this method calls every time when app started
  Future<void> _getDelay(
      TimerGetDelayEvent event, Emitter<TimerState> emit) async {
    final delay = await _getDelayUseCase(NoParams());

    delay.fold(
      (l) => emit(state.copyWith(
          settingsEntity: state.settingsEntity.copyWith(delay: 0))),
      (delay) => emit(state.copyWith(
          settingsEntity: state.settingsEntity.copyWith(delay: delay))),
    );
  }

  ///This method starts the [SpeedcubingTimer] After 13 milliseconds, the update method is called
  void _startListeningTimer() {
    _speedcubingTimer.startTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 13), (timer) {
      _updateTimer();
    });
  }

  ///This method stops the [SpeedcubingTimer]
  void _stopListeningTimer() {
    _speedcubingTimer.stopTimer();
    _timer?.cancel();
  }

  ///This method updates the current time state every 13 milliseconds
  void _updateTimer() {
    emit(state.copyWith(timeInMillis: _speedcubingTimer.getTime()));
  }
}
