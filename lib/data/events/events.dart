import 'package:hive_flutter/hive_flutter.dart';

part 'events.g.dart';

@HiveType(typeId: 1)
enum Event {
  @HiveField(0)
  event2by2,

  @HiveField(1)
  event3by3,

  @HiveField(2)
  eventPyra,

  @HiveField(3)
  eventSkewb,

  @HiveField(4)
  eventClock,
}
