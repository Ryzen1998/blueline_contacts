import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/contacts_controller.dart';

@immutable
class ContactState {
  final AsyncValue<List<Contact>> contacts;
  final ExpansionItemMaster expansionList;
  const ContactState({required this.contacts, required this.expansionList});

  ContactState copyWith(
      {AsyncValue<List<Contact>>? contacts,
      ExpansionItemMaster? expansionList}) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      expansionList: expansionList ?? this.expansionList,
    );
  }
}
