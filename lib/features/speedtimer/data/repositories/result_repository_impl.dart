import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/exceptions.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/result_local_data_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/result_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/result_repository.dart';

class ResultRepositoryImpl implements ResultRepository {

  ResultLocalDataSource resultLocalDataSource;

  ResultRepositoryImpl(this.resultLocalDataSource);

  @override
  Future<Either<Failure, List<ResultEntity>>> getAllResults(Event event) async {
    try {
      final results = await resultLocalDataSource.getAllResults(event);
      return Right(results.map((result) => result.mapToEntity()).toList());
    } on HiveException {
      return Left(HiveFailure());
    }
  }

  @override
  Future<Either<Failure, ResultEntity>> saveResult(ResultEntity resultEntity) async {
    try {
      final savedResult = await resultLocalDataSource.saveResult(ResultModel.mapFromEntity(resultEntity));
      return Right(savedResult.mapToEntity());
    } on HiveException {
      return Left(HiveFailure());
    }
  }

  @override
  Future<Either<Failure, ResultEntity>> updateResult(ResultEntity resultEntity, [int? index]) async {
    try {
      if (index != null) {
        final savedResult = await resultLocalDataSource.updateResult(
            ResultModel.mapFromEntity(resultEntity), index);
        return Right(savedResult.mapToEntity());
      } else {
        final savedResult = await resultLocalDataSource.updateResultById(
            ResultModel.mapFromEntity(resultEntity));
        return Right(savedResult.mapToEntity());
      }
    } on HiveException {
      return Left(HiveFailure());
    }

  }

  @override
  Future<Either<Failure, ResultEntity>> deleteResult(ResultEntity resultEntity, [int? index]) async {
    try {
      if (index != null) {
        final deletedResult = await resultLocalDataSource.deleteResult(
            ResultModel.mapFromEntity(resultEntity), index);
        return Right(deletedResult.mapToEntity());
      } else {
        final deletedResult = await resultLocalDataSource.deleteResultById(
            ResultModel.mapFromEntity(resultEntity));
        return Right(deletedResult.mapToEntity());
      }

    } on HiveException {
      return Left(HiveFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllResults(Event event) async {
    await resultLocalDataSource.deleteAllResults(event);
    return const Right(null);
  }


}