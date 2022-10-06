import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/domain/entity/result_avg_data.dart';

//1 - 2by2
//2 - 3by3
//3 - pyra
//4 - skewb
//5 - clock

abstract class SPKeys {
  static const eventKey = "event";

  static const best2by2Avg5 = "best2by2Avg5";
  static const best2by2Avg12 = "best2by2Avg12";
  static const best2by2Avg50 = "best2by2Avg50";
  static const best2by2Avg100 = "best2by2Avg100";

  static const best3by3Avg5 = "best3by3Avg5";
  static const best3by3Avg12 = "best3by3Avg12";
  static const best3by3Avg50 = "best3by3Avg50";
  static const best3by3Avg100 = "best3by3Avg100";

  static const bestPyraAvg5 = "bestPyraAvg5";
  static const bestPyraAvg12 = "bestPyraAvg12";
  static const bestPyraAvg50 = "bestPyraAvg50";
  static const bestPyraAvg100 = "best2PyraAvg100";

  static const bestSkewbAvg5 = "bestSkewbAvg5";
  static const bestSkewbAvg12 = "bestSkewbAvg12";
  static const bestSkewbAvg50 = "bestSkewbAvg50";
  static const bestSkewbAvg100 = "bestSkewbAvg100";

  static const bestClockAvg5 = "bestClockAvg5";
  static const bestClockAvg12 = "bestClockAvg12";
  static const bestClockAvg50 = "bestClockAvg50";
  static const bestClockAvg100 = "best2ClockAg100";
}

class _BestResultDataKeys {
  String bestAvg5;
  String bestAvg12;
  String bestAvg50;
  String bestAvg100;

  _BestResultDataKeys({required this.bestAvg5,
    required this.bestAvg12,
    required this.bestAvg50,
    required this.bestAvg100});
}

class SharedPreferencesStorage {
  static final instance = SharedPreferencesStorage._();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferencesStorage._();

  Future<void> setEvent(Event event) async {
    int i = _eventToInt(event);
    (await _prefs).setInt(SPKeys.eventKey, i);
  }

  Future<Event> getEvent() async {
    int i = (await _prefs).getInt(SPKeys.eventKey) ?? 2; // default 3by3
    return _intToEvent(i);
  }

  Future<ResultAvgData> getBestResultAvgData(Event event) async {
    _BestResultDataKeys bestResultDataKeys = _getKeysByEvent(event);
    return ResultAvgData(avg5: (await _prefs).getInt(bestResultDataKeys.bestAvg5),
        avg12: (await _prefs).getInt(bestResultDataKeys.bestAvg12),
        avg50: (await _prefs).getInt(bestResultDataKeys.bestAvg50),
        avg100: (await _prefs).getInt(bestResultDataKeys.bestAvg100));
  }

  Future<void> addResultAvgData(ResultAvgData resultData, Event event) async {
    _BestResultDataKeys bestResultDataKeys = _getKeysByEvent(event);
    final bestResultData = await getBestResultAvgData(event);
    if ((resultData.avg5 ?? double.infinity) < (bestResultData.avg5 ?? double.infinity)) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg5, resultData.avg5!);
    }
    if ((resultData.avg12 ?? double.infinity) < (bestResultData.avg12 ?? double.infinity)) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg12, resultData.avg12!);
    }
    if ((resultData.avg50 ?? double.infinity) < (bestResultData.avg50 ?? double.infinity)) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg50, resultData.avg50!);
    }
    if ((resultData.avg100 ?? double.infinity) < (bestResultData.avg100 ?? double.infinity)) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg100, resultData.avg100!);
    }
  }

  Future<void> setBestResultAvgData(ResultAvgData resultData, Event event) async {
    _BestResultDataKeys bestResultDataKeys = _getKeysByEvent(event);
    if (resultData.avg5 != null) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg5, resultData.avg5!);
    } else {
      (await _prefs).remove(bestResultDataKeys.bestAvg5);
    }

    if (resultData.avg12 != null) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg12, resultData.avg12!);
    } else {
      (await _prefs).remove(bestResultDataKeys.bestAvg12);
    }

    if (resultData.avg50 != null) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg50, resultData.avg50!);
    } else {
      (await _prefs).remove(bestResultDataKeys.bestAvg50);
    }

    if (resultData.avg100 != null) {
      (await _prefs).setInt(bestResultDataKeys.bestAvg100, resultData.avg100!);
    } else {
      (await _prefs).remove(bestResultDataKeys.bestAvg100);
    }
  }

  Future<void> deleteBestResultAvgData(Event event) async {
    _BestResultDataKeys bestResultDataKeys = _getKeysByEvent(event);
    (await _prefs).remove(bestResultDataKeys.bestAvg5);
    (await _prefs).remove(bestResultDataKeys.bestAvg12);
    (await _prefs).remove(bestResultDataKeys.bestAvg50);
    (await _prefs).remove(bestResultDataKeys.bestAvg100);
  }

  int _eventToInt(Event event) {
    switch (event) {
      case Event.event2by2:
        return 1;
      case Event.event3by3:
        return 2;
      case Event.eventPyra:
        return 3;
      case Event.eventSkewb:
        return 4;
      case Event.eventClock:
        return 5;
    }
  }

  Event _intToEvent(int i) {
    switch (i) {
      case 1:
        return Event.event2by2;
      case 2:
        return Event.event3by3;
      case 3:
        return Event.eventPyra;
      case 4:
        return Event.eventSkewb;
      case 5:
        return Event.eventClock;
      default:
        throw Exception("illegal argument $i to cast to event");
    }
  }

  _BestResultDataKeys _getKeysByEvent(Event event) {
    switch (event) {
      case Event.event2by2:
        return _BestResultDataKeys(
            bestAvg5: SPKeys.best2by2Avg5,
            bestAvg12: SPKeys.best2by2Avg12,
            bestAvg50: SPKeys.best2by2Avg50,
            bestAvg100: SPKeys.best2by2Avg100);
      case Event.event3by3:
        return _BestResultDataKeys(
            bestAvg5: SPKeys.best3by3Avg5,
            bestAvg12: SPKeys.best3by3Avg12,
            bestAvg50: SPKeys.best3by3Avg50,
            bestAvg100: SPKeys.best3by3Avg100);
      case Event.eventPyra:
        return _BestResultDataKeys(
            bestAvg5: SPKeys.bestPyraAvg5,
            bestAvg12: SPKeys.bestPyraAvg12,
            bestAvg50: SPKeys.bestPyraAvg50,
            bestAvg100: SPKeys.bestPyraAvg100);
      case Event.eventSkewb:
        return _BestResultDataKeys(
            bestAvg5: SPKeys.bestSkewbAvg5,
            bestAvg12: SPKeys.bestSkewbAvg12,
            bestAvg50: SPKeys.bestSkewbAvg50,
            bestAvg100: SPKeys.bestSkewbAvg100);
      case Event.eventClock:
        return _BestResultDataKeys(
            bestAvg5: SPKeys.bestClockAvg5,
            bestAvg12: SPKeys.bestClockAvg12,
            bestAvg50: SPKeys.bestClockAvg50,
            bestAvg100: SPKeys.bestClockAvg100);
    }
  }
}
