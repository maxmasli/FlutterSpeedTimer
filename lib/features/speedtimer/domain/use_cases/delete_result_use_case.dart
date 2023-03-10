import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/result_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class DeleteResultUseCase extends UseCase<ResultEntity, ParamsIndexedResult> {

  final ResultRepository resultRepository;

  DeleteResultUseCase({required this.resultRepository});

  @override
  Future<Either<Failure, ResultEntity>> call(ParamsIndexedResult params) async {
    return await resultRepository.deleteResult(params.resultEntity, params.index);
  }
}