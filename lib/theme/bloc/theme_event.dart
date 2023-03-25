part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeAppStartedEvent extends ThemeEvent {}

class ThemeSetPrimaryColorEvent extends ThemeEvent {
  final Color color;

  const ThemeSetPrimaryColorEvent(this.color);

  @override
  List<Object> get props => [color];
}

class ThemeSetSecondaryColorEvent extends ThemeEvent {
  final Color color;

  const ThemeSetSecondaryColorEvent(this.color);

  @override
  List<Object> get props => [color];
}

class ThemeSetTextColorEvent extends ThemeEvent {
  final Color color;

  const ThemeSetTextColorEvent(this.color);

  @override
  List<Object> get props => [color];
}
