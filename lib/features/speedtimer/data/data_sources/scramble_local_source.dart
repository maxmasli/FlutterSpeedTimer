import 'dart:math';

import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';

abstract class ScrambleLocalSource {
  String getScramble(Event event);
}

class ScrambleLocalSourceImpl implements ScrambleLocalSource {

  final _random = Random();

  @override
  String getScramble(Event event) {
    switch (event) {
      case Event.cube222:
        return _get2by2Scramble();
      case Event.cube333:
        return _get3by3Scramble();
      case Event.pyraminx:
        return _getPyraScramble();
      case Event.skewb:
        return _getSkewbScramble();
      case Event.clock:
        return _getClockScramble();
    }
  }

  String _get2by2Scramble() {
    final scrambleList = <String>[];
    var temp = -1;
    final lit = [
      ["R", "R'", "R2"],
      ["F", "F'", "F2"],
      ["U", "U'", "U2"]
    ];
    while (true) {
      final i = _random.nextInt(3);
      final j = _random.nextInt(3);
      if (temp == i) {
        continue;
      } else {
        temp = i;
        scrambleList.add(lit[i][j]);
      }
      if (scrambleList.length > 9) {
        break;
      }
    }

    return scrambleList.join(" ");
  }

  String _get3by3Scramble() {
    final lit = [
      ["F", "F'", "F2"],
      ["B", "B'", "B2"],
      ["U", "U'", "U2"],
      ["D", "D'", "D2"],
      ["R", "R'", "R2"],
      ["L", "L'", "L2"]
    ];

    final scrambleList = <String>[];
    final banned = <int>[];
    while (true) {
      final i = _random.nextInt(6); // [0, 5]
      final j = _random.nextInt(3); // [0, 2]
      if (scrambleList.length > 2 && scrambleList[scrambleList.length - 2] == lit[i][j] ||
          banned.contains(i)) {
        continue;
      }
      scrambleList.add(lit[i][j]);
      if (i % 2 != 0 && banned.contains(i - 1) || i % 2 == 0 && banned.contains(i + 1)) {
        banned.add(i);
      } else {
        banned.clear();
        banned.add(i);
      }
      if (scrambleList.length >= 20) {
        break;
      }
    }

    return scrambleList.join(" ");
  }

  String _getPyraScramble() {
    final cornersCount = _random.nextInt(5);
    var litCount = 0;
    var res = "";
    final buffer = <int>[];
    final lit = [
      ["L", "L'"],
      ["R", "R'"],
      ["U", "U'"],
      ["B", "B'"]
    ];
    while (true) {
      final i = _random.nextInt(4);
      final j = _random.nextInt(2);
      final generateLit = lit[i][j];
      if (buffer.contains(i)) {
        continue;
      } else {
        res += "$generateLit ";
        buffer.clear();
        buffer.add(i);
        litCount++;
        if (litCount >= 8) break;
      }
    }

    final cornersLit = [
      ["l", "l'"],
      ["r", "r'"],
      ["b", "b'"],
      ["u", "u'"]
    ];

    for (int count = 0; count < cornersCount; count++) {
      final i = _random.nextInt(cornersLit.length);
      final j = _random.nextInt(2);
      final generateLit = cornersLit[i][j];
      res += "$generateLit ";
      litCount++;
      cornersLit.removeAt(i);
    }

    return res;
  }

  String _getSkewbScramble() {
    final letterSet = ["R ", "R' ", "U ", "U' ", "B ", "B' ", "L ", "L' "];
    var newScramble = "";
    var iterator = 0;
    var randomNumber = 0;
    var tempRandom = 0;
    while (iterator < 11) {
      if (randomNumber % 2 == 0) {
        if (tempRandom == randomNumber || tempRandom == randomNumber + 1) {
          tempRandom = _random.nextInt(8); // [0, 7]
          continue;
        }
      }
      if (randomNumber % 2 == 1) {
        if (tempRandom == randomNumber || tempRandom == randomNumber - 1) {
          tempRandom = _random.nextInt(8);
          continue;
        }
      }
      randomNumber = tempRandom;
      newScramble += letterSet[randomNumber];
      iterator++;
    }
    return newScramble;
  }

  String _getClockScramble() {
    final scramble = [
      "UR",
      "num",
      "sign",
      "DR",
      "num",
      "sign",
      "DL",
      "num",
      "sign",
      "UL",
      "num",
      "sign",
      "U",
      "num",
      "sign",
      "R",
      "num",
      "sign",
      "D",
      "num",
      "sign",
      "L",
      "num",
      "sign",
      "ALL",
      "num",
      "sign",
      "y2 ",
      "U",
      "num",
      "sign",
      "R",
      "num",
      "sign",
      "D",
      "num",
      "sign",
      "L",
      "num",
      "sign",
      "ALL",
      "num",
      "sign",
      "",
      "",
      "",
      "",
      ""
    ];
    final letterNum = ["0", "1", "2", "3", "4", "5", "6"];
    final letterSign = ["+", "-"];
    final lastFour = ["UR ", "DR ", "DL ", "UL "];
    for (int i = 0; i < 27; i += 3) {
      scramble[i + 1] = letterNum[_random.nextInt(7)];
      scramble[i + 2] = letterSign[_random.nextInt(2)];
    }
    for (int i = 28; i < 41; i += 3) {
      scramble[i + 1] = letterNum[_random.nextInt(7)];
      scramble[i + 2] = letterSign[_random.nextInt(2)];
    }
    for (int i = 44; i < 48; i++) {
      if (_random.nextInt(2) == 1) {
        scramble[i] = lastFour[i - 44];
      }
    }
    var scrambleString = "";
    for (String j in scramble) {
      if (letterSign.contains(j)) {
        scrambleString += "$j ";
      } else {
        scrambleString += j;
      }
    }
    return scrambleString;
  }
}
