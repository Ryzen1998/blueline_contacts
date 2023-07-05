import 'dart:io';

import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter/material.dart';

class ContactCircleAvatar extends StatelessWidget {
  const ContactCircleAvatar({super.key, required this.contact});
  final Contact contact;

  Widget getContactTextAvatar() {
    if (contact.firstName.length > 1) {
      return Text(contact.firstName.substring(0, 1));
    }
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    if (contact.imagePath != null && contact.imagePath != '') {
      if (File(contact.imagePath!).existsSync()) {
        final img = File(contact.imagePath!);
        return CircleAvatar(
          backgroundImage: Image.file(img).image,
        );
      }
    }
    return CircleAvatar(
      child: getContactTextAvatar(),
    );
  }
}
