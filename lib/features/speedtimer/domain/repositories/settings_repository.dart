import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';

abstract class SettingsRepository {
  Future<Either<Failure, double>> getDelay();
  Future<Either<Failure, void>> saveDelay(double delay);
}