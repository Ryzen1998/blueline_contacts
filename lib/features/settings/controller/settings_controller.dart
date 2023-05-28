import 'package:blueline_contacts/features/settings/service/SettingService.dart';
import 'package:blueline_contacts/features/settings/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsControllerProvider =
    StateNotifierProvider.autoDispose<SettingsController, SettingsState>((ref) {
  return SettingsController(
      const SettingsState(
          AsyncValue.data(false), AsyncValue.data(''), AsyncValue.data(false)),
      ref.watch(settingsServiceProvider));
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(SettingsState state, this._settingService) : super(state) {
    loadSettings();
  }
  final SettingService _settingService;

  Future<void> loadSettings() async {
    state = state.copyWith(
        isPasscodeLockEnabled: const AsyncValue.loading(),
        passcodeString: const AsyncValue.loading());

    final passCodeStatus = await _settingService
        .getBooleanSharedPreference('isPasscodeLockEnabled');

    final passCodeString =
        await _settingService.getStringSharedPreference('passcodeString');

    state = state.copyWith(
        isPasscodeLockEnabled: AsyncValue.data(passCodeStatus),
        passcodeString: AsyncValue.data(passCodeString),
        isValidLogin: AsyncValue.data(!passCodeStatus));
  }

  Future<void> changePreferenceBooleanStatus(bool status, String key) async {
    await _settingService.setBooleanSharedPreference(status, key);
    loadSettings();
  }

  Future<bool> getPreferenceBooleanStatus(String key) async {
    return await _settingService.getBooleanSharedPreference(key);
  }

  Future<void> changePreferenceString(String key, String value) async {
    await _settingService.setStringSharedPreference(key, value);
    loadSettings();
  }

  Future<String> getPreferenceString(String key) async {
    return await _settingService.getStringSharedPreference(key);
  }

  Future<void> setAuthenticationStatus(bool status) async {
    state = state.copyWith(isValidLogin: AsyncValue.data(status));
  }
}
