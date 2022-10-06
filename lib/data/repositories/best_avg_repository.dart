import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/data/storage/shared_prefs_storage.dart';
import 'package:speedtimer_fltr/domain/entity/result_avg_data.dart';

class BestAvgRepository {
  final _sharedPreferencesStorage = SharedPreferencesStorage.instance;

  Future<ResultAvgData> getBestResultAvgData(Event event) async {
    return await _sharedPreferencesStorage.getBestResultAvgData(event);
  }

  Future<void> addResultAvgData(ResultAvgData resultData, Event event) async {
    await _sharedPreferencesStorage.addResultAvgData(resultData, event);
  }

  Future<void> deleteBestResultAvgData(Event event) async {
    await _sharedPreferencesStorage.deleteBestResultAvgData(event);
  }

  Future<void> setBestResultAvgData(ResultAvgData resultData, Event event) async {
    await _sharedPreferencesStorage.setBestResultAvgData(resultData, event);
  }
}