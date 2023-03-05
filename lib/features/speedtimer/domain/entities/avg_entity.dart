import 'package:equatable/equatable.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';

class AvgEntity extends Equatable {
  final int? avg5;
  final int? avg12;
  final int? avg50;
  final int? avg100;

  const AvgEntity({
    required this.avg5,
    required this.avg12,
    required this.avg50,
    required this.avg100,
  });

  String get stringAvg5 => millisToString(avg5);
  String get stringAvg12 => millisToString(avg12);
  String get stringAvg50 => millisToString(avg50);
  String get stringAvg100 => millisToString(avg100);

  @override
  List<Object?> get props => [avg5, avg12, avg50, avg100];
}