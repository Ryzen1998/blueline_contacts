import 'package:blueline_contacts/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ExpansionTile(
              leading: const Icon(Icons.security_rounded),
              title: const Text(
                'Security',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.black54,
                ),
              ),
              children: [
                ListTile(
                  title: const Text('Enable Passcode Lock'),
                  trailing: Switch(
                    value: ref
                        .watch(settingsControllerProvider)
                        .isPasscodeLockEnabled
                        .when(data: (data) {
                      return data;
                    }, error: (error, trc) {
                      return false;
                    }, loading: () {
                      return false;
                    }),
                    onChanged: (selected) {
                      if (selected) {
                        final controller = InputController();
                        screenLockCreate(
                          context: context,
                          digits: 5,
                          inputController: controller,
                          onConfirmed: (matchedText) {
                            ref
                                .read(settingsControllerProvider.notifier)
                                .changePreferenceBooleanStatus(
                                    selected, 'isPasscodeLockEnabled');
                            ref
                                .read(settingsControllerProvider.notifier)
                                .changePreferenceString(
                                    'passcodeString', matchedText);
                            Navigator.of(context).pop();
                          },
                          footer: TextButton(
                            onPressed: () {
                              // Release the confirmation state and return to the initial input state.
                              controller.unsetConfirmed();
                            },
                            child: const Text('Reset input'),
                          ),
                        );
                      } else {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .changePreferenceBooleanStatus(
                                false, 'isPasscodeLockEnabled');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
