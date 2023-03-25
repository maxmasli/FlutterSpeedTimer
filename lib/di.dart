import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/avg_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/result_local_data_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/scramble_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/data_sources/settings_local_source.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/repositories/avg_repository_impl.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/repositories/result_repository_impl.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/repositories/scramble_repository_impl.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/repositories/settings_repository_impl.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/avg_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/result_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/scramble_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/repositories/settings_repository.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/compare_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/delete_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_all_results_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_best_avg_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_best_sovle_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_delay_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/get_scramble_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/save_delay_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/save_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/use_cases/update_result_use_case.dart';
import 'package:speedtimer_flutter/features/speedtimer/presentation/bloc/timer_bloc.dart';
import 'package:speedtimer_flutter/theme/bloc/theme_bloc.dart';
import 'package:speedtimer_flutter/theme/data/data_sources/theme_local_source.dart';
import 'package:speedtimer_flutter/theme/data/repositories/theme_repository_impl.dart';
import 'package:speedtimer_flutter/theme/domain/repositories/theme_repository.dart';
import 'package:speedtimer_flutter/theme/domain/use_cases/get_theme_use_case.dart';
import 'package:speedtimer_flutter/theme/domain/use_cases/save_theme_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //bloc
  sl.registerFactory(() => TimerBloc(
        getAllResultsUseCase: sl(),
        saveResultUseCase: sl(),
        getScrambleUseCase: sl(),
        updateLastResultUseCase: sl(),
        deleteResultUseCase: sl(),
        getAvgUseCase: sl(),
        getBestAvgUseCase: sl(),
        compareBestAvgUseCase: sl(),
        deleteAllResultsUseCase: sl(),
        getBestSolveUseCase: sl(),
        getDelayUseCase: sl(),
        saveDelayUseCase: sl(),
      ));

  sl.registerFactory(() => ThemeBloc(
        getThemeUseCase: sl(),
        saveThemeUseCase: sl(),
      ));

  //use cases
  sl.registerLazySingleton(() => GetAllResultsUseCase(resultRepository: sl()));
  sl.registerLazySingleton(() => SaveResultUseCase(resultRepository: sl()));
  sl.registerLazySingleton(() => GetScrambleUseCase(scrambleRepository: sl()));
  sl.registerLazySingleton(() => UpdateResultUseCase(resultRepository: sl()));
  sl.registerLazySingleton(() => DeleteResultUseCase(resultRepository: sl()));
  sl.registerLazySingleton(() => GetAvgUseCase(avgRepository: sl()));
  sl.registerLazySingleton(() => GetBestAvgUseCase(avgRepository: sl()));
  sl.registerLazySingleton(() => CompareBestAvgUseCase(avgRepository: sl()));
  sl.registerLazySingleton(() => GetBestSolveUseCase(avgRepository: sl()));
  sl.registerLazySingleton(
      () => DeleteAllResultsUseCase(resultRepository: sl()));
  sl.registerLazySingleton(() => GetDelayUseCase(settingsRepository: sl()));
  sl.registerLazySingleton(() => SaveDelayUseCase(settingsRepository: sl()));

  sl.registerLazySingleton(() => GetThemeUseCase(themeRepository: sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(themeRepository: sl()));

  //repository
  sl.registerLazySingleton<ResultRepository>(() => ResultRepositoryImpl(sl()));
  sl.registerLazySingleton<ScrambleRepository>(
      () => ScrambleRepositoryImpl(sl()));
  sl.registerLazySingleton<AvgRepository>(() => AvgRepositoryImpl(sl()));
  sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()));

  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(sl()));

  //Data sources
  sl.registerLazySingleton<ResultLocalDataSource>(
      () => ResultLocalDataSourceImpl());
  sl.registerLazySingleton<ScrambleLocalSource>(
      () => ScrambleLocalSourceImpl());
  sl.registerLazySingleton<AvgLocalSource>(
      () => AvgLocalSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<SettingsLocalSource>(
      () => SettingsLocalSourceImpl(sl()));

  sl.registerLazySingleton<ThemeLocalSource>(
      () => ThemeLocalSourceImpl(sharedPreferences: sl()));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final controller = PageController(
    initialPage: 1,
  );
  sl.registerSingleton<PageController>(controller);
}
