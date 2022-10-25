import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/utils/consts.dart';

part 'result_entity.g.dart';

@HiveType(typeId: 2)
class ResultEntity {
  @HiveField(0)
  int time;

  @HiveField(1)
  String scramble;

  @HiveField(2)
  String description;

  @HiveField(3)
  Event event;

  @HiveField(4)
  bool isDNF;

  @HiveField(5)
  bool isPlus;

  @HiveField(6)
  int index;

  int getTime() {
    if (isPlus) return time + PENALTY_TIME;
    return time;
  }

  bool get isDescriptionEmpty => description.isEmpty;

  ResultEntity(
      {required this.time,
      required this.scramble,
      required this.description,
      required this.event,
      required this.isDNF,
      required this.isPlus,
      required this.index});
}
