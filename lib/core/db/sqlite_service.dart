import 'package:blueline_contacts/model/contact.dart';
import 'package:blueline_contacts/model/contact_detail.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  final String databaseName = "bluelineContacts.db";

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    try {
      return openDatabase(
        path,
        onCreate: (database, version) async {
          await database.execute(
            "CREATE TABLE IF NOT EXISTS BLCONTACTS"
            "(ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "FIRSTNAME TEXT,LASTNAME TEXT,EMAIL TEXT)",
          );
          await database.execute(
            "CREATE TABLE IF NOT EXISTS BLCONTACTSDETAIL"
            "(ID INTEGER,NICK TEXT,NUMBER TEXT,FOREIGN KEY(ID) REFERENCES BLCONTACTS (ID)"
            " ON DELETE CASCADE "
            "ON UPDATE NO ACTION)",
          );
        },
        version: 1,
      );
    } on Exception catch (e) {}
    return openDatabase('');
  }

  Future<int> createContact(Contact contact) async {
    int result = 0;
    if (contact.id == null) {
      final Database db = await initDb();
      result = await db.insert('BLCONTACTS', contact.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (contact.contactDetail != null && contact.contactDetail!.isNotEmpty) {
        for (ContactDetail detail in contact.contactDetail!) {
          detail.id = result;
          await db.insert('BLCONTACTSDETAIL', detail.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      db.close();
    } else {
      result = await updateContact(contact);
    }
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    int result = 0;
    final Database db = await initDb();
    result = await db.update('BLCONTACTS', contact.toMap(),
        where: "ID=?", whereArgs: [contact.id]);

    if (contact.contactDetail != null && contact.contactDetail!.isNotEmpty) {
      for (ContactDetail detail in contact.contactDetail!) {
        await db.update('BLCONTACTSDETAIL', detail.toMap(),
            where: 'ID=?', whereArgs: [detail.id]);
      }
    }
    db.close();

    return result;
  }

  Future<List<Contact>> getAllContacts() async {
    final Database db = await initDb();
    final List<Map<String, Object?>> contactQueryResult =
        await db.query("BLCONTACTS");

    List<Contact> contacts =
        contactQueryResult.map((e) => Contact.fromMap(e)).toList();
    final List<Map<String, Object?>> contactDetailQueryResult =
        await db.query("BLCONTACTSDETAIL");

    List<ContactDetail> detailList =
        contactDetailQueryResult.map((e) => ContactDetail.fromMap(e)).toList();
    db.close();
    for (Contact item in contacts) {
      item.contactDetail
          ?.addAll(detailList.where((x) => x.id == item.id).toList());
    }
    return contacts;
  }

  Future<void> deleteContact(int id) async {
    final Database db = await initDb();
    await db.delete('BLCONTACTS', where: "ID=?", whereArgs: [id]);
    await db.delete('BLCONTACTSDETAIL', where: "ID=?", whereArgs: [id]);
    db.close();
  }
}
