import 'package:equatable/equatable.dart';
import 'package:speedtimer_flutter/theme/domain/entities/theme_entity.dart';

class ThemeModel extends Equatable {
  final int primaryColor;
  final int secondaryColor;
  final int textColor;

  const ThemeModel({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });

  factory ThemeModel.fromEntity(ThemeEntity themeEntity) {
    return ThemeModel(
      primaryColor: themeEntity.primaryColor,
      secondaryColor: themeEntity.secondaryColor,
      textColor: themeEntity.textColor,
    );
  }

  ThemeEntity toEntity() {
    return ThemeEntity(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textColor: textColor);
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'textColor': textColor,
    };
  }

  factory ThemeModel.fromJson(Map<String, dynamic> map) {
    return ThemeModel(
      primaryColor: map['primaryColor'] as int,
      secondaryColor: map['secondaryColor'] as int,
      textColor: map['textColor'] as int,
    );
  }

  @override
  List<Object> get props => [primaryColor, secondaryColor, textColor];
}
