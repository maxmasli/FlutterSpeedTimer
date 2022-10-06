import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/data/helpers/result_counter.dart';
import 'package:speedtimer_fltr/data/repositories/best_avg_repository.dart';
import 'package:speedtimer_fltr/data/repositories/result_repository.dart';
import 'package:speedtimer_fltr/data/repositories/settings_repository.dart';
import 'package:speedtimer_fltr/domain/entity/result_avg_data.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';

class ResultViewModelState {
  List<ResultEntity> results = [];
  var event = Event.event3by3;
  ResultAvgData resultAvgData = ResultAvgData(avg5: null, avg12: null, avg50: null, avg100: null);

  ResultAvgData bestResultAvgData =
      ResultAvgData(avg5: null, avg12: null, avg50: null, avg100: null);

  int? best = 0;
  int total = 0;

  ResultEntity? resultInBottomSheet;
}

class ResultViewModel extends ChangeNotifier {
  final _resultRepository = ResultRepository();
  final _settingsRepository = SettingsRepository();
  final _bestResultRepository = BestAvgRepository();
  final _resultCounter = ResultCounter();

  final viewModelState = ResultViewModelState();

  ResultViewModel() {
    init();
  }

  void init() async {
    await _update();
  }

  Future<void> _update() async {
    await getAllResults();
    await _recountAvg();
  }

  Future<void> getAllResults() async {
    viewModelState.event = await _settingsRepository.getEvent();
    final results = await _resultRepository.getAllResultsByEvent(viewModelState.event);
    viewModelState.results = results;
    notifyListeners();
  }

  void setResultInBottomSheet(ResultEntity resultEntity) {
    viewModelState.resultInBottomSheet = resultEntity;
    notifyListeners();
  }

  void setDNFFromBottomSheet() {
    final isDNF = !viewModelState.resultInBottomSheet!.isDNF;
    print("set dnf = $isDNF");

    final newResult = ResultEntity(
        time: viewModelState.resultInBottomSheet!.time,
        scramble: viewModelState.resultInBottomSheet!.scramble,
        description: viewModelState.resultInBottomSheet!.description,
        event: viewModelState.resultInBottomSheet!.event,
        isDNF: isDNF,
        isPlus: viewModelState.resultInBottomSheet!.isPlus,
        index: viewModelState.resultInBottomSheet!.index);

    viewModelState.resultInBottomSheet = newResult;

    _updateResult(viewModelState.resultInBottomSheet!);

    _update();

    notifyListeners();
  }

  Future<void> _saveResult(ResultEntity result) async {
    await _resultRepository.saveResult(result);
  }

  Future<void> _updateResult(ResultEntity resultEntity) async {
    await _resultRepository.updateResult(resultEntity);
  }

  Future<void> deleteResults() async {
    await _resultRepository.deleteResultsByEvent(viewModelState.event);
    _bestResultRepository.deleteBestResultAvgData(viewModelState.event);

    viewModelState.results = [];
    await _recountAvg();

    notifyListeners();
  }

  Future<void> deleteResultFromBottomSheet() async {
    _resultRepository.deleteResult(viewModelState.resultInBottomSheet!);
    viewModelState.resultInBottomSheet = null;
    _update();
    //принудительный пересчет авг()
  }

  Future<void> _recountAvg() async {
    viewModelState.bestResultAvgData =
        await _bestResultRepository.getBestResultAvgData(viewModelState.event);

    final resultAvgData = ResultAvgData(
        avg5: _resultCounter.getAvg(5, viewModelState.results),
        avg12: _resultCounter.getAvg(12, viewModelState.results),
        avg50: _resultCounter.getAvg(50, viewModelState.results),
        avg100: _resultCounter.getAvg(100, viewModelState.results));

    viewModelState.resultAvgData = resultAvgData;
    viewModelState.best = _resultCounter.getBest(viewModelState.results);
    viewModelState.total = _resultCounter.getCount(viewModelState.results);
  }
}
