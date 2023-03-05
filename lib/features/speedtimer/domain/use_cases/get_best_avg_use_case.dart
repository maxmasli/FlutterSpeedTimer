import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/avg_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class GetBestAvgUseCase extends UseCase<AvgEntity, ParamsEventList> {

  final AvgRepository avgRepository;

  GetBestAvgUseCase({
    required this.avgRepository,
  });

  @override
  Future<Either<Failure, AvgEntity>> call(ParamsEventList params) {
     return avgRepository.getBestAvg(params.event, params.results, params.forceRecount);
  }

}