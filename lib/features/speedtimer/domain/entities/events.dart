import 'package:hive_flutter/hive_flutter.dart';

part 'events.g.dart';

@HiveType(typeId: 2)
enum Event{
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

