import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';
import 'package:speedtimer_flutter/theme/domain/repositories/theme_repository.dart';

class GetThemeUseCase extends UseCase<ThemeEntity, NoParams> {
  final ThemeRepository themeRepository;

  GetThemeUseCase({required this.themeRepository});

  @override
  Future<Either<Failure, ThemeEntity>> call(NoParams params) async {
    return await themeRepository.getTheme();
  }
}
