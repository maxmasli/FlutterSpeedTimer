import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';

part 'result_model.g.dart';

@HiveType(typeId: 1)
class ResultModel extends Equatable {
  @HiveField(0)
  final int timeInMillis;

  @HiveField(1)
  final String scramble;

  @HiveField(2)
  final bool isPlus2;

  @HiveField(3)
  final bool isDNF;

  @HiveField(4)
  final Event event;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String uuid;

  const ResultModel(
      {required this.timeInMillis,
      required this.scramble,
      required this.isPlus2,
      required this.isDNF,
      required this.event,
      required this.description,
      required this.uuid});

  int? get time {
    if (isDNF) {
      return null;
    }
    if (isPlus2) {
      return timeInMillis + penaltyInMillis;
    }
    return timeInMillis;
  }

  ResultEntity mapToEntity() {
    return ResultEntity(
      timeInMillis: timeInMillis,
      scramble: scramble,
      isPlus2: isPlus2,
      isDNF: isDNF,
      event: event,
      description: description,
      uuid: uuid,
    );
  }

  factory ResultModel.mapFromEntity(ResultEntity resultEntity) {
    return ResultModel(
      timeInMillis: resultEntity.timeInMillis,
      description: resultEntity.description,
      isPlus2: resultEntity.isPlus2,
      scramble: resultEntity.scramble,
      event: resultEntity.event,
      isDNF: resultEntity.isDNF,
      uuid: resultEntity.uuid,
    );
  }

  @override
  List<Object> get props =>
      [timeInMillis, scramble, isPlus2, isDNF, event, description, uuid];
}
