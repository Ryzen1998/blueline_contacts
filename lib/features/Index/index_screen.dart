import 'package:blueline_contacts/features/contacts/controller/contacts_controller.dart';
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
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ref.watch(contactsControllerProvider).contacts.when(
                    data: (contacts) {
                      return const ContactListView();
                    },
                    error: (err, trace) {
                      return const Text('something went wrong');
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 10),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onChanged: (value) {
                  ref
                      .read(contactsControllerProvider.notifier)
                      .searchContacts(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  label: const Text(
                    'Search',
                    style: TextStyle(fontSize: 20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: FloatingActionButton(
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
          ),
        ],
      ),
    );
  }
}
