import 'package:flutter/material.dart';

import '../../../features/settings/screen/settings.dart';

class SideBarContent extends StatelessWidget {
  const SideBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: const Text(
        'Settings',
        style: TextStyle(
          fontSize: 17,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: Colors.black45,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
      },
    );
  }
}
