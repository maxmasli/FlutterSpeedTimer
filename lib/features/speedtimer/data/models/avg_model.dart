import 'package:equatable/equatable.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';

class AvgModel extends Equatable {
  final int? avg5;
  final int? avg12;
  final int? avg50;
  final int? avg100;

  const AvgModel({
    required this.avg5,
    required this.avg12,
    required this.avg50,
    required this.avg100,
  });

  AvgEntity mapToEntity() {
    return AvgEntity(
      avg5: avg5,
      avg12: avg12,
      avg50: avg50,
      avg100: avg100,
    );
  }

  factory AvgModel.mapFromEntity(AvgEntity entity) {
    return AvgModel(
      avg5: entity.avg5,
      avg12: entity.avg12,
      avg50: entity.avg50,
      avg100: entity.avg100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avg5': avg5,
      'avg12': avg12,
      'avg50': avg50,
      'avg100': avg100,
    };
  }

  factory AvgModel.fromJson(Map<String, dynamic> map) {
    return AvgModel(
      avg5: map['avg5'] as int?,
      avg12: map['avg12'] as int?,
      avg50: map['avg50'] as int?,
      avg100: map['avg100'] as int?,
    );
  }

  AvgModel copyWith({
    int? avg5,
    int? avg12,
    int? avg50,
    int? avg100,
  }) {
    return AvgModel(
      avg5: avg5 ?? this.avg5,
      avg12: avg12 ?? this.avg12,
      avg50: avg50 ?? this.avg50,
      avg100: avg100 ?? this.avg100,
    );
  }

  AvgModel copyWithByInt(int avg, int? value) {
    switch(avg) {
      case 5: return copyWith(avg5: value);
      case 12: return copyWith(avg12: value);
      case 50: return copyWith(avg50: value);
      case 100: return copyWith(avg100: value);
      default: return copyWith(avg5: value);
    }
  }

  @override
  List<Object?> get props => [avg5, avg12, avg50, avg100];


}
