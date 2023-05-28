import 'package:blueline_contacts/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'lock_screen_animation.dart';

class LockScreen extends ConsumerWidget {
  const LockScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String getPasscode() {
      late String result;
      ref
          .watch(settingsControllerProvider)
          .passcodeString
          .whenData((value) => result = value);
      return result;
    }

    return Center(
      child: ScreenLock(
        correctString: getPasscode(),
        secretsBuilder: (
          context,
          config,
          length,
          input,
          verifyStream,
        ) =>
            SecretsWithCustomAnimation(
          verifyStream: verifyStream,
          config: config,
          input: input,
          length: length,
        ),
        onUnlocked: () {
          ref
              .read(settingsControllerProvider.notifier)
              .setAuthenticationStatus(true);
          Navigator.of(context).pop;
        },
      ),
    );
  }
}
