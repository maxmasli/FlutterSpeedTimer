import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:speedtimer_fltr/resources/resources.dart';

void main() {
  test('svgs assets test', () {
    expect(File(Svgs.iconClock).existsSync(), true);
    expect(File(Svgs.icon2by2).existsSync(), true);
    expect(File(Svgs.icon3by3).existsSync(), true);
    expect(File(Svgs.iconPyra).existsSync(), true);
    expect(File(Svgs.iconSkewb).existsSync(), true);
  });
}
