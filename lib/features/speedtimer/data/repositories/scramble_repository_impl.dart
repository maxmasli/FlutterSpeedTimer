import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/scramble_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/scramble_repository.dart';

class ScrambleRepositoryImpl implements ScrambleRepository {

  final ScrambleLocalSource scrambleLocalDataSource;


  ScrambleRepositoryImpl(this.scrambleLocalDataSource);

  @override
  Future<Either<Failure, String>> getScramble(Event event) {
    return Future.value(Right(scrambleLocalDataSource.getScramble(event)));
  }
}