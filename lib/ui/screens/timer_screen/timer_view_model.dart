import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/data/helpers/result_counter.dart';
import 'package:speedtimer_fltr/data/repositories/best_avg_repository.dart';
import 'package:speedtimer_fltr/data/repositories/result_repository.dart';
import 'package:speedtimer_fltr/data/repositories/scramble_repository.dart';
import 'package:speedtimer_fltr/data/repositories/settings_repository.dart';
import 'package:speedtimer_fltr/domain/entity/result_avg_data.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';
import 'package:speedtimer_fltr/utils/speedcubing_timer.dart';

enum TimerState { stop, running, readyToStart }

class _TimerViewModelState {
  var state = TimerState.stop;
  var scramble = "";
  var event = Event.event3by3;
  var time = 0;
  var resultAvgData = ResultAvgData(avg5: null, avg12: null, avg50: null, avg100: null);
  var bestResultAvgData = ResultAvgData(avg5: null, avg12: null, avg50: null, avg100: null);
  var previousBestResultAvgData = ResultAvgData(avg5: null, avg12: null, avg50: null, avg100: null);
  int? best = 0;
  int total = 0;
  ResultEntity? currentResult;
}

class TimerViewModel extends ChangeNotifier {
  final _resultRepository = ResultRepository();
  final _scrambleRepository = ScrambleRepository();
  final _settingsRepository = SettingsRepository();
  final _resultCounter = ResultCounter();
  final _bestResultRepository = BestAvgRepository();

  final viewModelState = _TimerViewModelState();
  final _speedcubingTimer = SpeedcubingTimer();
  Timer? _timer;

  TimerViewModel() {
    init();
  }

  void init() async {
    viewModelState.event = await _settingsRepository.getEvent();
    _generateScramble();
    _recountAvg();
  }

  void onTapDown() {
    if (viewModelState.state == TimerState.stop) {
      viewModelState.state = TimerState.readyToStart;
    } else if (viewModelState.state == TimerState.running) {
      viewModelState.state = TimerState.stop; // timer stop
      _stopTimer();
    }
    notifyListeners();
  }

  void onTapUp() {
    if (viewModelState.state == TimerState.readyToStart) {
      viewModelState.state = TimerState.running; // timer start
      _startTimer();
    }
    notifyListeners();
  }

  void setEvent(Event event) {
    _settingsRepository.setEvent(event);
    viewModelState.event = event;
    _generateScramble();
    _recountAvg();
  }

  void setDNF() async {
    if (viewModelState.currentResult == null) return;
    final updatedResult = viewModelState.currentResult;
    final isDNF = !updatedResult!.isDNF;
    updatedResult.isDNF = isDNF;
    viewModelState.currentResult = updatedResult;

    print("set dnf ${viewModelState.currentResult!.isDNF}");
    await _resultRepository.popLastResult(viewModelState.event);

    await _saveCurrentResult(updatedResult);
    _recountAvg(recountAgain: true);
    notifyListeners();
  }

  void setPlus() async {
    if (viewModelState.currentResult == null) return;
    final updatedResult = viewModelState.currentResult;
    final isPlus = !updatedResult!.isPlus;
    updatedResult.isPlus = isPlus;
    viewModelState.currentResult = updatedResult;

    print("set +2 ${viewModelState.currentResult!.isPlus}");
    await _resultRepository.popLastResult(viewModelState.event);

    await _saveCurrentResult(updatedResult);
    _recountAvg(recountAgain: true);
    notifyListeners();
  }

  void _startTimer() {
    _speedcubingTimer.startTimer();
    _startListeningTimer();
  }

  void _stopTimer() async {
    _speedcubingTimer.stopTimer();
    _stopListeningTimer();
    _updateTimer(); // update to see the last time

    await _saveResult();

    _recountAvg();
    _generateScramble();
  }

  void _generateScramble() {
    viewModelState.scramble = _scrambleRepository.getScramble(viewModelState.event);
    notifyListeners();
  }

  Future<void> _saveCurrentResult(ResultEntity resultEntity) async {
    await _resultRepository.saveResult(resultEntity);
  }

  Future<void> _saveResult() async {
    final time = viewModelState.time;
    final scramble = viewModelState.scramble;

    viewModelState.currentResult = ResultEntity(
        time: time,
        scramble: scramble,
        description: '',
        event: viewModelState.event,
        isDNF: false,
        isPlus: false,
        index: ResultRepository.lastIndex);

    await _resultRepository.saveResult(viewModelState.currentResult!);
  }

  void _recountAvg({bool recountAgain = false}) async {
    if (recountAgain) {
      final results = await _resultRepository.getAllResultsByEvent(viewModelState.event);
      final resultAvgData = ResultAvgData(
          avg5: _resultCounter.getAvg(5, results),
          avg12: _resultCounter.getAvg(12, results),
          avg50: _resultCounter.getAvg(50, results),
          avg100: _resultCounter.getAvg(100, results));

      final bestAvgData = _resultCounter.connectResultAvgData(
          resultAvgData, viewModelState.previousBestResultAvgData);
      await _bestResultRepository.setBestResultAvgData(bestAvgData, viewModelState.event);

      viewModelState.resultAvgData = resultAvgData;
      viewModelState.bestResultAvgData = bestAvgData;
      viewModelState.best = _resultCounter.getBest(results);
      notifyListeners();
      return;
    }

    viewModelState.previousBestResultAvgData = viewModelState.bestResultAvgData;

    final results = await _resultRepository.getAllResultsByEvent(viewModelState.event);
    final resultAvgData = ResultAvgData(
        avg5: _resultCounter.getAvg(5, results),
        avg12: _resultCounter.getAvg(12, results),
        avg50: _resultCounter.getAvg(50, results),
        avg100: _resultCounter.getAvg(100, results));

    viewModelState.resultAvgData = resultAvgData;

    await _bestResultRepository.addResultAvgData(resultAvgData, viewModelState.event);

    viewModelState.bestResultAvgData =
        await _bestResultRepository.getBestResultAvgData(viewModelState.event);

    viewModelState.best = _resultCounter.getBest(results);
    viewModelState.total = _resultCounter.getCount(results);
    notifyListeners();
  }

  void _startListeningTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _updateTimer();
    });
  }

  void _stopListeningTimer() {
    _timer?.cancel();
  }

  void _updateTimer() {
    viewModelState.time = _speedcubingTimer.getTime();
    notifyListeners();
  }
}
