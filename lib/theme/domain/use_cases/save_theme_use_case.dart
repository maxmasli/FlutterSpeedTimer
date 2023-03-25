import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';
import 'package:speedtimer_flutter/theme/domain/repositories/theme_repository.dart';

class SaveThemeUseCase extends UseCase<void, ThemeParams> {
  final ThemeRepository themeRepository;

  SaveThemeUseCase({required this.themeRepository});

  @override
  Future<Either<Failure, void>> call(ThemeParams params) async {
    return await themeRepository.saveTheme(params.themeEntity);
  }
}

class ThemeParams {
  final ThemeEntity themeEntity;

  ThemeParams(this.themeEntity);
}
