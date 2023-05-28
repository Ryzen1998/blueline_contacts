import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingService {
  Future<void> setBooleanSharedPreference(bool status, String key);
  Future<void> setStringSharedPreference(String key, String value);
  Future<bool> getBooleanSharedPreference(String key);
  Future<String> getStringSharedPreference(String key);

  Future<void> removePreferenceByKey(String key);
}

final settingsServiceProvider = Provider<SettingService>((ref) {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  return BlSettingService(prefs);
});

class BlSettingService implements SettingService {
  BlSettingService(this._prefs);
  final Future<SharedPreferences> _prefs;

  @override
  Future<void> setBooleanSharedPreference(bool status, String key) async {
    try {
      final sharedPreference = await _prefs;
      await sharedPreference.setBool(key, status);
    } catch (e) {}
  }

  @override
  Future<bool> getBooleanSharedPreference(String key) async {
    final sharedPreference = await _prefs;
    final result = sharedPreference.getBool(key);
    return result ?? false;
  }

  @override
  Future<void> setStringSharedPreference(String key, String value) async {
    try {
      final sharedPreference = await _prefs;
      await sharedPreference.setString(key, value);
    } catch (e) {}
  }

  @override
  Future<String> getStringSharedPreference(String key) async {
    final sharedPreference = await _prefs;
    final result = sharedPreference.getString(key);
    return result ?? '';
  }

  @override
  Future<void> removePreferenceByKey(String key) async {
    final sharedPreference = await _prefs;
    await sharedPreference.remove(key);
  }
}
