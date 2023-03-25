import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/settings_repository.dart';

class GetDelayUseCase extends UseCase<double, NoParams> {
  final SettingsRepository settingsRepository;

  GetDelayUseCase({
    required this.settingsRepository,
  });

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await settingsRepository.getDelay();
  }
}
