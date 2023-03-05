import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';

abstract class ResultRepository {
  Future<Either<Failure, List<ResultEntity>>> getAllResults(Event event);

  Future<Either<Failure, ResultEntity>> saveResult(ResultEntity resultEntity);

  Future<Either<Failure, ResultEntity>> updateResult(ResultEntity resultEntity, int index);

  Future<Either<Failure, ResultEntity>> deleteResult(Event event, int index);

  Future<Either<Failure, void>> deleteAllResults(Event event);
}
