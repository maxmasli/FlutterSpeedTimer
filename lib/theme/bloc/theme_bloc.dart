import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/core/use_case/use_case.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';
import 'package:speedtimer_flutter/theme/domain/use_cases/get_theme_use_case.dart';
import 'package:speedtimer_flutter/theme/domain/use_cases/save_theme_use_case.dart';
import 'package:speedtimer_flutter/theme/theme_data_builder.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeUseCase _getThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;

  ThemeBloc(
      {required SaveThemeUseCase saveThemeUseCase,
      required GetThemeUseCase getThemeUseCase})
      : _getThemeUseCase = getThemeUseCase,
        _saveThemeUseCase = saveThemeUseCase,
        super(ThemeState(ThemeData.light())) {
    on<ThemeAppStartedEvent>(appStarted);
    on<ThemeSetPrimaryColorEvent>(setPrimaryColor);
    on<ThemeSetSecondaryColorEvent>(setSecondaryColor);
    on<ThemeSetTextColorEvent>(setTextColor);
  }

  Future<void> appStarted(ThemeAppStartedEvent event, Emitter<ThemeState> emit) async {
    final theme = await _getThemeUseCase(NoParams());
    theme.fold(
      (l) => emit(ThemeState(ThemeDataBuilder.buildThemeData(
          Color(defaultTheme.primaryColor),
          Color(defaultTheme.secondaryColor),
          Color(defaultTheme.textColor)))),

      (themeEntity) => emit(ThemeState(ThemeDataBuilder.buildThemeData(
          Color(themeEntity.primaryColor),
          Color(themeEntity.secondaryColor),
          Color(themeEntity.textColor)))),
    );
  }

  Future<void> setPrimaryColor(
      ThemeSetPrimaryColorEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeState(ThemeDataBuilder.buildThemeData(
        event.color,
        state.theme.colorScheme.secondary,
        state.theme.textTheme.bodyMedium!.color!)));

    await _saveThemeUseCase(ThemeParams(ThemeEntity(
      primaryColor: event.color.value,
      secondaryColor: state.theme.colorScheme.secondary.value,
      textColor: state.theme.textTheme.bodyMedium!.color!.value,
    )));
  }

  Future<void> setSecondaryColor(
      ThemeSetSecondaryColorEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeState(ThemeDataBuilder.buildThemeData(
        state.theme.colorScheme.primary,
        event.color,
        state.theme.textTheme.bodyMedium!.color!)));

    await _saveThemeUseCase(ThemeParams(ThemeEntity(
      primaryColor: state.theme.colorScheme.primary.value,
      secondaryColor: event.color.value,
      textColor: state.theme.textTheme.bodyMedium!.color!.value,
    )));
  }

  Future<void> setTextColor(ThemeSetTextColorEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeState(ThemeDataBuilder.buildThemeData(
        state.theme.colorScheme.primary,
        state.theme.colorScheme.secondary,
        event.color)));

    await _saveThemeUseCase(ThemeParams(ThemeEntity(
      primaryColor: state.theme.colorScheme.primary.value,
      secondaryColor: state.theme.colorScheme.secondary.value,
      textColor: event.color.value,
    )));
  }
}
