import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/db/sqlite_service.dart';

abstract class ContactsService {
  Future<Result<List<Contact>, Error>> getAllContact();
  Future<Result<int, Error>> addNewContact(Contact contact);
  Future<void> deleteContact(int id);
}

final contactsServiceProvider = Provider<ContactsService>((ref) {
  final SqliteService dbService = SqliteService();
  return BlContactService(dbService);
});

class BlContactService implements ContactsService {
  BlContactService(this._dbService);
  final SqliteService _dbService;

  @override
  Future<Result<List<Contact>, Error>> getAllContact() async {
    try {
      final contactsList = await _dbService.getAllContacts();
      return Success(contactsList);
    } on Error catch (e) {
      return Error(e);
    }
  }

  @override
  Future<Result<int, Error>> addNewContact(Contact contact) async {
    try {
      final result = await _dbService.createContact(contact);
      return Success(result);
    } on Error catch (e) {
      return Error(e);
    }
  }

  @override
  Future<void> deleteContact(int id) async {
    await _dbService.deleteContact(id);
  }
}
