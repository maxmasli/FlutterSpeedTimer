import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/avg_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class CompareBestAvgUseCase extends UseCase<AvgEntity, ParamsBestAvgs>{

  final AvgRepository avgRepository;

  CompareBestAvgUseCase({
    required this.avgRepository,
  });

  @override
  Future<Either<Failure, AvgEntity>> call(ParamsBestAvgs params) async {
    return await avgRepository.compareBestAvg(params.a, params.b, params.event);
  }
}