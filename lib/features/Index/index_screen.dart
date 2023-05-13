import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/bluelineappbar/controller/custom_appbar_controller.dart';
import '../../core/widgets/bluelineappbar/custom_appbar.dart';
import '../../model/contact.dart';
import '../contacts/screen/contacts_listview_screen.dart';
import '../contacts/screen/new_contact_screen.dart';

class Index extends ConsumerWidget {
  const Index({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() {
      ref
          .read(customAppBarProvider.notifier)
          .changeTitleText('Contact Manager');
    });
    return Scaffold(
      appBar: CustomAppBar(),
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
