import 'package:equatable/equatable.dart';
import 'package:speedtimer_flutter/core/utils/consts.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/core/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ResultEntity extends Equatable {
  final int timeInMillis;
  final String scramble;
  final bool isPlus2;
  final bool isDNF;
  final Event event;
  final String description;
  final String uuid;

  const ResultEntity({
    required this.timeInMillis,
    required this.scramble,
    required this.isPlus2,
    required this.isDNF,
    required this.event,
    required this.description,
    required this.uuid,
  });

  int? get time {
    if (isDNF) {
      return null;
    }
    if (isPlus2) {
      return timeInMillis + penaltyInMillis;
    }
    return timeInMillis;
  }

  String get stringTime {
    return millisToString(time);
  }

  ResultEntity copyWith({
    int? timeInMillis,
    String? scramble,
    bool? isPlus2,
    bool? isDNF,
    Event? event,
    String? description,
    String? uuid,
  }) {
    return ResultEntity(
      timeInMillis: timeInMillis ?? this.timeInMillis,
      scramble: scramble ?? this.scramble,
      isPlus2: isPlus2 ?? this.isPlus2,
      isDNF: isDNF ?? this.isDNF,
      event: event ?? this.event,
      description: description ?? this.description,
      uuid: uuid ?? this.uuid,
    );
  }

  @override
  List<Object> get props =>
      [timeInMillis, scramble, isPlus2, isDNF, event, description, uuid];
}
