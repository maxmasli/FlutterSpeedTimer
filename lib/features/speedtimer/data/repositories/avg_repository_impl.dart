import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/avg_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/avg_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/result_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/avg_repository.dart';

class AvgRepositoryImpl implements AvgRepository {
  AvgLocalSource avgLocalSource;

  AvgRepositoryImpl(this.avgLocalSource);

  @override
  Future<Either<Failure, AvgEntity>> getAvg(List<ResultEntity> results) async {
    try {
      final avg = await avgLocalSource.getAvg(
          results.map((entity) => ResultModel.mapFromEntity(entity)).toList());
      return Right(avg.mapToEntity());
    } catch (_) {
      return Left(CubingFailure());
    }
  }

  ///getting best avg from shared preferences, if avg == null, calculating best avg and save
  @override
  Future<Either<Failure, AvgEntity>> getBestAvg(
      Event event, List<ResultEntity> results, bool forceRecount) async {
    final avg = await avgLocalSource.getBestAvg(event);
    if (avg != null && !forceRecount) { /// if (avg != null && !forceRecount)
      return Right(avg.mapToEntity());
    } else {
      final bestAvg = avgLocalSource.calculateBestAvg(
          results.map((entity) => ResultModel.mapFromEntity(entity)).toList());
      await avgLocalSource.saveBestAvg(event, bestAvg);
      return Right(bestAvg.mapToEntity());
    }
  }

  @override
  Future<Either<Failure, AvgEntity>> compareBestAvg(
      AvgEntity a, AvgEntity b, Event event) async {
    return Right((await avgLocalSource.compareBestAvgAndSave(
            AvgModel.mapFromEntity(a), AvgModel.mapFromEntity(b), event))
        .mapToEntity());
  }
}
