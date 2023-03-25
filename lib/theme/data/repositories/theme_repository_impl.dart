import 'package:dartz/dartz.dart';
import 'package:speedtimer_flutter/core/error/failure.dart';
import 'package:speedtimer_flutter/theme/data/data_sources/theme_local_source.dart';
import 'package:speedtimer_flutter/theme/data/models/theme_model.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';
import 'package:speedtimer_flutter/theme/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl extends ThemeRepository {
  final ThemeLocalSource themeLocalSource;

  ThemeRepositoryImpl(this.themeLocalSource);

  @override
  Future<Either<Failure, ThemeEntity>> getTheme() async {
    return Right((await themeLocalSource.getTheme()).toEntity());
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeEntity themeEntity) async {
    return Right(
        await themeLocalSource.saveTheme(ThemeModel.fromEntity(themeEntity)));
  }
}
