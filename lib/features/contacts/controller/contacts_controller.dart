import 'package:blueline_contacts/features/contacts/contact_state.dart';
import 'package:blueline_contacts/features/contacts/service/contacts_service.dart';
import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpansionItem {
  Contact data;
  bool isExpanded = false;
  ExpansionItem({required this.data, required this.isExpanded});
}

class ExpansionItemMaster {
  ExpansionItemMaster({required this.contactList});

  final List<Contact> contactList;

  late List<ExpansionItem> expansionItem = contactList.map((e) {
    return ExpansionItem(data: e, isExpanded: false);
  }).toList();

  ExpansionItemMaster getExpansionListMaster() {
    final ExpansionItemMaster masterList =
        ExpansionItemMaster(contactList: contactList);
    return masterList;
  }
}

final contactsControllerProvider =
    StateNotifierProvider.autoDispose<ContactsController, ContactState>((ref) {
  return ContactsController(
      ContactState(
        contacts: const AsyncValue.data([]),
        expansionList: ExpansionItemMaster(contactList: []),
      ),
      ref.watch(contactsServiceProvider));
});

class ContactsController extends StateNotifier<ContactState> {
  ContactsController(ContactState state, this._contactsService) : super(state) {
    loadContacts();
  }
  final ContactsService _contactsService;

  Future<void> loadContacts() async {
    state = state.copyWith(contacts: const AsyncValue.loading());
    final result = await _contactsService.getAllContact();
    result.when((contacts) {
      state = state.copyWith(
          contacts: AsyncValue.data(contacts),
          expansionList: ExpansionItemMaster(contactList: contacts));
    }, (error) {
      state =
          state.copyWith(contacts: AsyncValue.error(error, StackTrace.current));
    });
  }

  Future<void> addContact(Contact contact) async {
    final result = await _contactsService.addNewContact(contact);
    result.when((success) => loadContacts(), (error) => null);
  }

  Future<void> deleteContact(int id) async {
    await _contactsService.deleteContact(id);
    loadContacts();
  }
}
