import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/Index/index_screen.dart';
import 'features/lockscreen/lock_screen.dart';
import 'features/settings/controller/settings_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          ref.watch(settingsControllerProvider).isValidLogin.when(data: (data) {
        if (!data) {
          return const LockScreen();
        } else {
          return const Index();
        }
      }, error: (e, s) {
        return const Text('Something went wrong');
      }, loading: () {
        return const CircularProgressIndicator();
      }),
    );
  }
}
