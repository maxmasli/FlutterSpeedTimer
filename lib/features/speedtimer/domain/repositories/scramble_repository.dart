import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';

abstract class ScrambleRepository {
  Future<Either<Failure, String>> getScramble(Event event);
}