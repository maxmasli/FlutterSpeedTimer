import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/domain/entity/result_entity.dart';
import 'package:speedtimer_fltr/speed_timer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(ResultEntityAdapter());
  runApp(const SpeedTimer());
}