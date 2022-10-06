import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';

abstract class BoxNames {
  static const event3by3 = "event_3by3";
  static const event2by2 = "event_2by2";
  static const eventPyra = "event_pyra";
  static const eventSkewb = "event_skewb";
  static const eventClock = "event_clock";
}

class ResultRepository {
  static int lastIndex = 0;

  Future<List<ResultEntity>> getAllResultsByEvent(Event event) async {
    print("getting all results");

    final boxName = _getBoxName(event);
    final box = await Hive.openBox<ResultEntity>(boxName);

    final results = box.values.toList();

    lastIndex = results.length;

    for (var r in results) {
      print(r.index);
    }

    await box.close();
    return results;
  }

  Future<void> updateResult(ResultEntity resultEntity) async {
    final boxName = _getBoxName(resultEntity.event);
    final box = await Hive.openBox<ResultEntity>(boxName);

    final resultToUpdate =
        box.values.where((_resultEntity) => _resultEntity.index == resultEntity.index).toList()[0];
    final index = box.values.toList().indexOf(resultToUpdate);

    await box.putAt(index, resultEntity);
    await box.close();
  }

  Future<void> saveResult(ResultEntity result) async {
    print("save result");

    final boxName = _getBoxName(result.event);
    final box = await Hive.openBox<ResultEntity>(boxName);
    await box.add(result);
    lastIndex = box.values.length;
    await box.close();
  }

  Future<void> deleteResultsByEvent(Event event) async {
    final boxName = _getBoxName(event);
    final box = await Hive.openBox<ResultEntity>(boxName);
    await box.deleteFromDisk();
    await box.close();
    lastIndex = 0;
  }

  Future<ResultEntity> popLastResult(Event event) async {
    final boxName = _getBoxName(event);
    final box = await Hive.openBox<ResultEntity>(boxName);
    final index = box.values.length - 1;
    final key = await box.keyAt(index);
    final result = box.get(key);
    await box.delete(key);
    lastIndex = box.values.length;
    if (result == null) throw Exception("pop last result Result == null");
    await box.close();
    return result;
  }

  Future<void> deleteResult(ResultEntity resultEntity) async {
    final boxName = _getBoxName(resultEntity.event);
    final box = await Hive.openBox<ResultEntity>(boxName);

    final resultToUpdate =
        box.values.where((_resultEntity) => _resultEntity.index == resultEntity.index).toList()[0];
    final index = box.values.toList().indexOf(resultToUpdate);

    lastIndex = box.values.length - 1;

    await box.deleteAt(index);

    await box.close();
  }

  String _getBoxName(Event event) {
    late String boxName;
    switch (event) {
      case Event.event2by2:
        {
          boxName = BoxNames.event2by2;
          break;
        }
      case Event.event3by3:
        {
          boxName = BoxNames.event3by3;
          break;
        }
      case Event.eventPyra:
        {
          boxName = BoxNames.eventPyra;
          break;
        }
      case Event.eventSkewb:
        {
          boxName = BoxNames.eventSkewb;
          break;
        }
      case Event.eventClock:
        {
          boxName = BoxNames.eventClock;
          break;
        }
    }
    return boxName;
  }
}
