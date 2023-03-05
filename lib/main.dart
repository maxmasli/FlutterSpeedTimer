import 'package:flutter/material.dart';
import 'package:speedtimer_flutter/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedtimer_flutter/features/speedtimer/data/models/result_model.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ResultModelAdapter());
  Hive.registerAdapter(EventAdapter());
  await di.init();
  runApp(const App());
}