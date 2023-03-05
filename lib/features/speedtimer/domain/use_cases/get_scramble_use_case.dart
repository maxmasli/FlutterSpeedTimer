import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/scramble_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/params.dart';

class GetScrambleUseCase extends UseCase<String, ParamsEvent> {

  final ScrambleRepository scrambleRepository;

  GetScrambleUseCase({required this.scrambleRepository});

  @override
  Future<Either<Failure, String>> call(ParamsEvent params) {
    return scrambleRepository.getScramble(params.event);
  }
}

