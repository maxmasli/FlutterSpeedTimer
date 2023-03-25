import 'package:hive_flutter/hive_flutter.dart';

part 'events.g.dart';

@HiveType(typeId: 2)
enum Event {
  @HiveField(0)
  cube222,
  @HiveField(1)
  cube333,
  @HiveField(2)
  pyraminx,
  @HiveField(3)
  skewb,
  @HiveField(4)
  clock
}

extension ParseToString on Event {
  String toEventString() {
    switch (this) {
      case Event.cube222:
        return "2x2x2";
      case Event.cube333:
        return "3x3x3";
      case Event.pyraminx:
        return "Pyraminx";
      case Event.skewb:
        return "Skewb";
      case Event.clock:
        return "Clock";
    }
  }
}
