import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalSource {
  Future<double> getDelay();
  Future<void> saveDelay(double delay);
}

class SettingsLocalSourceImpl extends SettingsLocalSource {

  final delayKey = "delay_key";

  final SharedPreferences sharedPreferences;

  SettingsLocalSourceImpl(this.sharedPreferences);

  @override
  Future<double> getDelay() async {
    return sharedPreferences.getDouble(delayKey) ?? 0;
  }

  @override
  Future<void> saveDelay(double delay) async {
    await sharedPreferences.setDouble(delayKey, delay);
  }

}