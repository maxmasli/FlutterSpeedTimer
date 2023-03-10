import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/avg_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class GetBestSolveUseCase extends UseCase<ResultEntity?, ParamsListResult> {

  final AvgRepository avgRepository;

  GetBestSolveUseCase({
    required this.avgRepository,
  });

  @override
  Future<Either<Failure, ResultEntity?>> call(ParamsListResult params) {
    return avgRepository.getBestSolve(params.results);
  }
}
