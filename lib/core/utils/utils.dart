import 'package:flutter_svg/flutter_svg.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/resources/resources.dart';

String millisToString(int? millis) {
  if (millis == null) return "DNF";
  var result = "";
  final hours = millis ~/ 3600000;
  var timestamp = millis % 3600000;
  final minutes = timestamp ~/ 60000;
  timestamp %= 60000;
  final seconds = timestamp ~/ 1000;
  final m = timestamp % 1000;
  if (hours != 0) {
    result += "$hours:";
  }
  if (minutes != 0 && hours != 0) {
    if (minutes < 10) {
      result += "0$minutes:";
    } else {
      result += "$minutes:";
    }
  }
  if (minutes != 0 && hours == 0) {
    result += "$minutes:";
  }
  if (minutes == 0 && hours != 0) {
    result += "00:";
  }
  if (seconds != 0 && minutes != 0) {
    if (seconds < 10) {
      result += "0$seconds.";
    } else {
      result += "$seconds.";
    }
  }
  if (seconds != 0 && minutes == 0) {
    result += "$seconds.";
  }
  if (seconds == 0 && minutes != 0) {
    result += "00.";
  }
  if (seconds == 0 && minutes == 0 && hours != 0) {
    result += "00:00.";
  }
  if (seconds == 0 && minutes == 0 && hours == 0) {
    result += "0.";
  }

  if (m == 0) {
    result += "000";
  } else if (m < 10) {
    result += "00$m";
  } else if (m < 100) {
    result += "0$m";
  } else if (m < 1000) {
    result += "$m";
  }
  return result;
}

String getSvgAssetByEvent(Event event) {
  switch (event) {
    case Event.cube222:
      return Svgs.c222;
    case Event.cube333:
      return Svgs.c333;
    case Event.pyraminx:
      return Svgs.pyram;
    case Event.skewb:
      return Svgs.skewb;
    case Event.clock:
      return Svgs.clock;
  }
}
