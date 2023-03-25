import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<Either<Failure, void>> saveTheme(ThemeEntity themeEntity);
  Future<Either<Failure, ThemeEntity>> getTheme();
}