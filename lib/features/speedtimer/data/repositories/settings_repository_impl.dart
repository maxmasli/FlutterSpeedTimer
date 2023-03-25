import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/settings_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {

  SettingsLocalSource settingsLocalSource;

  SettingsRepositoryImpl(this.settingsLocalSource);

  @override
  Future<Either<Failure, double>> getDelay() async {
    return Right(await settingsLocalSource.getDelay());
  }

  @override
  Future<Either<Failure, void>> saveDelay(double delay) async {
    return Right(await settingsLocalSource.saveDelay(delay));
  }


}