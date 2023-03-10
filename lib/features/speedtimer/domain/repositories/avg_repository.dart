import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';

abstract class AvgRepository {
  Future<Either<Failure, AvgEntity>> getAvg(List<ResultEntity> results);
  Future<Either<Failure, AvgEntity>> getBestAvg(Event event, List<ResultEntity> results, bool forceRecount);
  Future<Either<Failure, AvgEntity>> compareBestAvg(AvgEntity a, AvgEntity b, Event event);
  Future<Either<Failure, ResultEntity?>> getBestSolve(List<ResultEntity> results);
}