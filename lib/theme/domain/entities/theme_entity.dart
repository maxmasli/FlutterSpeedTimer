import 'package:equatable/equatable.dart';

class ThemeEntity extends Equatable {
  final int primaryColor;
  final int secondaryColor;
  final int textColor;

  const ThemeEntity({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });

  @override
  List<Object> get props => [primaryColor, secondaryColor, textColor];
}