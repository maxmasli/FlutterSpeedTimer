import 'dart:convert';

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/avg_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/result_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';

abstract class AvgLocalSource {
  Future<AvgModel> getAvg(List<ResultModel> results);

  Future<AvgModel?> getBestAvg(Event event);

  AvgModel calculateBestAvg(List<ResultModel> results);

  Future<void> saveBestAvg(Event event, AvgModel bestAvg);

  Future<AvgModel> compareBestAvg(AvgModel a, AvgModel b, Event event);
}

class AvgLocalSourceImpl implements AvgLocalSource {
  final SharedPreferences sharedPreferences;

  const AvgLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<AvgModel> getAvg(List<ResultModel> results) {
    return Future.value(AvgModel(
      avg5: _getAvgBy(5, results),
      avg12: _getAvgBy(12, results),
      avg50: _getAvgBy(50, results),
      avg100: _getAvgBy(100, results),
    ));
  }

  int? _getAvgBy(int avg, List<ResultModel> results) {
    if (results.length < avg) return null;
    final resultListWithEnabledResult =
        results.reversed.toList().sublist(0, avg); // only usable results
    final resultTimeList = <int?>[];

    var nullCounter = 0;
    for (var result in resultListWithEnabledResult) {
      if (result.isDNF) {
        resultTimeList.add(null);
        nullCounter++;
      } else if (result.isPlus2) {
        resultTimeList.add(result.timeInMillis + 2000);
      } else {
        resultTimeList.add(result.timeInMillis);
      }
    }

    if (nullCounter >= 2) {
      // if count of null >= 2
      return null;
    }

    var bestElem = double.infinity;
    int? worstElem = 0;

    for (var time in resultTimeList) {
      if (time == null) worstElem = null;
      if (time != null) {
        if (time < bestElem) {
          bestElem = time.toDouble();
        }
      }
      if (time != null) {
        if (worstElem != null && time > worstElem) {
          worstElem = time;
        }
      }
    }

    resultTimeList.remove(bestElem.toInt());
    resultTimeList.remove(worstElem);
    int sum = 0;

    for (var time in resultTimeList) {
      sum += time!;
    }
    return sum ~/ (avg - 2);
  }

  @override
  Future<AvgModel?> getBestAvg(Event event) {
    final json = sharedPreferences.getString(event.name);
    if (json == null) {
      return Future.value(null);
    } else {
      final bestAvg = AvgModel.fromJson(jsonDecode(json));
      return Future.value(bestAvg);
    }
  }

  @override
  AvgModel calculateBestAvg(List<ResultModel> results) {

    int? bestAvg;
    final bestAvgs = <int?>[null, null, null, null];
    final avgs = <int>[5, 12, 50, 100];
    for (var avg in avgs) {
      if (results.length < avg) {
        //avgModel.copyWithByInt(avg, null);
        final index = avgs.indexOf(avg);
        bestAvgs[index] = null;
        continue;
      }

      final countAvgs = results.length - avg + 1;
      for (int i = 0; i < countAvgs; i++) {
        final sublistResults = results.sublist(i, avg + i);
        final currentAvg = _getAvgBy(avg, sublistResults);
        bestAvg = _bestResult(bestAvg, currentAvg);
      }
      bestAvgs[avgs.indexOf(avg)] = bestAvg;
      bestAvg = null;
    }

    return AvgModel(
      avg5: bestAvgs[0],
      avg12: bestAvgs[1],
      avg50: bestAvgs[2],
      avg100: bestAvgs[3],
    );
  }

  @override
  Future<void> saveBestAvg(Event event, AvgModel bestAvg) async {
    await sharedPreferences.setString(event.name, jsonEncode(bestAvg.toJson()));
  }

  @override
  Future<AvgModel> compareBestAvg(
      AvgModel a, AvgModel b, Event event) async {
    int? bestAvg5 = _bestResult(a.avg5, b.avg5);
    int? bestAvg12 = _bestResult(a.avg12, b.avg12);
    int? bestAvg50 = _bestResult(a.avg50, b.avg50);
    int? bestAvg100 = _bestResult(a.avg100, b.avg100);
    final bestAvg = AvgModel(
        avg5: bestAvg5, avg12: bestAvg12, avg50: bestAvg50, avg100: bestAvg100);

    return Future.value(bestAvg);
  }

  int? _bestResult(int? a, int? b) {
    if (a == null && b == null) return null;
    if (a == null && b != null) return b;
    if (a != null && b == null) return a;
    return min(a!, b!);
  }
}
