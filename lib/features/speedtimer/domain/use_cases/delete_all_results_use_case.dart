import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/result_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class DeleteAllResultsUseCase extends UseCase<void, ParamsEvent> {

  ResultRepository resultRepository;

  DeleteAllResultsUseCase({
    required this.resultRepository,
  });

  @override
  Future<Either<Failure, void>> call(ParamsEvent params) async {
    return await resultRepository.deleteAllResults(params.event);
  }
}