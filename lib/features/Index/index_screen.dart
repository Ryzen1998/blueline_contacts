import 'package:blueline_contacts/features/settings/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/bluelineappbar/custom_appbar.dart';
import '../../model/contact.dart';
import '../contacts/screen/contacts_listview_screen.dart';
import '../contacts/screen/new_contact_screen.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  ConsumerState<Index> createState() => _IndexState();
}

class _IndexState extends ConsumerState<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: SafeArea(
        child: Drawer(
          width: 200,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
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
                  ),
                ],
              )),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              key: UniqueKey(),
              child: const ContactListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewContactScreen(
                contact: Contact.init(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
