import 'package:speedtimer_flutter/core/error/exceptions.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/result_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ResultLocalDataSource {
  Future<List<ResultModel>> getAllResults(Event event);

  Future<ResultModel> saveResult(ResultModel resultModel);

  Future<ResultModel> updateResult(ResultModel resultModel, int index);

  Future<ResultModel> deleteResult(Event event, int index);

  Future<void> deleteAllResults(Event event);
}

class ResultLocalDataSourceImpl implements ResultLocalDataSource {

  @override
  Future<List<ResultModel>> getAllResults(Event event) async {
    List<ResultModel> results = <ResultModel>[];
    final box = await Hive.openBox<ResultModel>(event.toString());
    final length = box.length;

    for (int i = 0; i < length; i++) {
      ResultModel? result = box.getAt(i);
      if (result == null) {
        throw HiveException("Result from ${event.toString()} is null");
      }results.add(result);
    }

    await box.close();
    return results;
  }

  @override
  Future<ResultModel> saveResult(ResultModel resultModel) async {
    final box = await Hive.openBox<ResultModel>(resultModel.event.toString());
    await box.add(resultModel);
    await box.close();
    return resultModel;
  }

  @override
  Future<ResultModel> updateResult(ResultModel resultModel, int index) async {
    final box = await Hive.openBox<ResultModel>(resultModel.event.toString());
    await box.putAt(index, resultModel);
    await box.close();
    return resultModel;
  }

  @override
  Future<ResultModel> deleteResult(Event event, int index) async {
    final box = await Hive.openBox<ResultModel>(event.toString());
    final deletedResult = box.getAt(index);
    await box.deleteAt(index);
    await box.close();
    if (deletedResult == null) {
      throw HiveException("deleteResult, deletedResult == null");
    }
    return deletedResult;
  }

  @override
  Future<void> deleteAllResults(Event event) async {
    final box = await Hive.openBox<ResultModel>(event.toString());
    await box.deleteFromDisk();
    await box.close();
  }
}
