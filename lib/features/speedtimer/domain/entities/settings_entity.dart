import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final double delay;

  const SettingsEntity({
    required this.delay,
  });

  SettingsEntity copyWith({
    double? delay,
  }) {
    return SettingsEntity(
      delay: delay ?? this.delay,
    );
  }

  @override
  List<Object> get props => [delay];
}