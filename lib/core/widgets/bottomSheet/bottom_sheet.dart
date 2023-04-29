import 'package:blueline_contacts/features/contacts/controller/contacts_controller.dart';
import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/contacts/screen/new_contact_screen.dart';

class BlueLineUiElement {
  static void blShowModalBottomSheet(
      BuildContext context, Contact contact, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewContactScreen(
                      contact: contact,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                blShowMyDialog(context, contact, ref);
              },
              leading: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              title: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> blShowMyDialog(
      BuildContext context, Contact contact, WidgetRef ref) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete ${contact.firstName}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                ref
                    .read(contactsControllerProvider.notifier)
                    .deleteContact(contact.id!.toInt());
              },
            ),
          ],
        );
      },
    );
  }
}
