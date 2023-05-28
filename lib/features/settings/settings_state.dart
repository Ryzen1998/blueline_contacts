import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class SettingsState {
  const SettingsState(
      this.isPasscodeLockEnabled, this.passcodeString, this.isValidLogin);
  final AsyncValue<bool> isPasscodeLockEnabled;
  final AsyncValue<String> passcodeString;
  final AsyncValue<bool> isValidLogin;

  SettingsState copyWith(
      {final AsyncValue<bool>? isPasscodeLockEnabled,
      final AsyncValue<String>? passcodeString,
      final AsyncValue<bool>? isValidLogin}) {
    return SettingsState(
      isPasscodeLockEnabled ?? this.isPasscodeLockEnabled,
      passcodeString ?? this.passcodeString,
      isValidLogin ?? this.isValidLogin,
    );
  }
}
