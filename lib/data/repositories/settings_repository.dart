import 'dart:async';

import 'package:speedtimer_fltr/data/events/events.dart';
import 'package:speedtimer_fltr/data/storage/shared_prefs_storage.dart';

class SettingsRepository {
  final _sharedPreferencesStorage = SharedPreferencesStorage.instance;

  Future<void> setEvent(Event event) async {
    await _sharedPreferencesStorage.setEvent(event);
  }

  Future<Event> getEvent() async {
    return await _sharedPreferencesStorage.getEvent();
  }
}