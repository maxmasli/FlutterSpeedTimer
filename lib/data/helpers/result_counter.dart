import 'dart:math';

import 'package:speedtimer_fltr/domain/entity/result_avg_data.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';

class ResultCounter {
  int getCount(List<ResultEntity> results) => results.length;

  int? getBest(List<ResultEntity> results) {
    int? min;
    for (var result in results) {
      var penalty = 0;
      if (result.isDNF) continue;
      if (result.isPlus) penalty += 2000;
      if (min == null) {
        min = result.time + penalty;
        continue;
      }
      if (result.time + penalty < min) min = result.time + penalty;
    }

    return min;
  }

  int? getAvg(int avg, List<ResultEntity> results) {
    if (results.length < avg) return null;
    final resultListWithEnabledResult =
        results.reversed.toList().sublist(0, avg); // only usable results
    final resultTimeList = <int?>[];

    var nullCounter = 0;
    for (var result in resultListWithEnabledResult) {
      if (result.isDNF) {
        resultTimeList.add(null);
        nullCounter++;
      } else if (result.isPlus) {
        resultTimeList.add(result.time + 2000);
      } else {
        resultTimeList.add(result.time);
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

  ResultAvgData findBestResultAvgData(List<ResultEntity> results) {
    final bestResultAvgData = ResultAvgData(
      avg5: null,
      avg12: null,
      avg50: null,
      avg100: null,
    );
    int? bestAvg;
    final bestAvgs = <int?> [];
    final avgs = <int>[5, 12, 50, 100];
    for (var avg in avgs) {
      if (results.length < avg) {
        bestResultAvgData.avg5 = null;
        continue;
      }

      final countAvgs = results.length - avg + 1;
      for (int i = 0; i < countAvgs; i++){
        final sublistResults = results.sublist(i, avg + i);
        final currentAvg = getAvg(avg, sublistResults);
        bestAvg = _bestAvg(bestAvg, currentAvg);
      }
      bestAvgs[avgs.indexOf(avg)] = bestAvg;
      bestAvg = null;
    }

    bestResultAvgData.avg5 = bestAvgs[0];
    bestResultAvgData.avg12 = bestAvgs[1];
    bestResultAvgData.avg50 = bestAvgs[2];
    bestResultAvgData.avg100 = bestAvgs[3];

    return bestResultAvgData;
  }

  ResultAvgData connectResultAvgData(ResultAvgData first, ResultAvgData second) {
    int? bestAvg5 = _bestAvg(first.avg5, second.avg5);
    int? bestAvg12 = _bestAvg(first.avg12, second.avg12);
    int? bestAvg50 = _bestAvg(first.avg50, second.avg50);
    int? bestAvg100 = _bestAvg(first.avg100, second.avg100);
    return ResultAvgData(avg5: bestAvg5, avg12: bestAvg12, avg50: bestAvg50, avg100: bestAvg100);
  }

  int? _bestAvg(int? a, int? b) {
    if (a == null && b == null) return null;
    if (a == null && b != null) return b;
    if (a != null && b == null) return a;
    return min(a!, b!);
  }
}
