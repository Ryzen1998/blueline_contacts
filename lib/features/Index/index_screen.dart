import 'package:blueline_contacts/core/widgets/sidebar/sidebar_content.dart';
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
      drawer: const SafeArea(
        child: Drawer(
          width: 200,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [SideBarContent()],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        height: 50,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: const Row(
            children: <Widget>[Spacer(), DrawerButton()],
          ),
        ),
      ),
    );
  }
}
