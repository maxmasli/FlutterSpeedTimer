import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/settings_repository.dart';

class SaveDelayUseCase extends UseCase<void, ParamsDelay> {
  final SettingsRepository settingsRepository;

  SaveDelayUseCase({
    required this.settingsRepository,
  });

  @override
  Future<Either<Failure, void>> call(ParamsDelay params) async {
    return await settingsRepository.saveDelay(params.delay);
  }
}

class ParamsDelay {
  final double delay;

  ParamsDelay(this.delay);
}
