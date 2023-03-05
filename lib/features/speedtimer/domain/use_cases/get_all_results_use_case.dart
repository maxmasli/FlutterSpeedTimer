import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/result_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class GetAllResultsUseCase extends UseCase<List<ResultEntity>, ParamsEvent> {
  final ResultRepository resultRepository;

  GetAllResultsUseCase({required this.resultRepository});

  @override
  Future<Either<Failure, List<ResultEntity>>> call(ParamsEvent params) async {
    return await resultRepository.getAllResults(params.event);
  }
}

