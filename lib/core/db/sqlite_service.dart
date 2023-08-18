import 'dart:io';

import 'package:blueline_contacts/model/contact.dart';
import 'package:blueline_contacts/model/contact_detail.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
          await database.execute(
            "CREATE TABLE IF NOT EXISTS BLPFPICS"
            "(ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTACTID TEXT UNIQUE,FULLPATH TEXT)",
          );
        },
        onUpgrade: (database, version, ints) async {
          await database.execute(
            "CREATE TABLE IF NOT EXISTS BLPFPICS"
            "(ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTACTID TEXT UNIQUE,FULLPATH TEXT)",
          );
        },
        version: 6,
      );
    } on Exception catch (e) {}
    return openDatabase('');
  }

  Future<int> createContact(Contact contact, File image) async {
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
      if (result != 0) {
        late String imagePath;
        if (contact.imagePath != '' && await image.exists()) {
          imagePath = await saveImageToDocumentPath(image);
        } else {
          imagePath = '';
        }
        await db.rawInsert(
            'INSERT INTO BLPFPICS (CONTACTID,FULLPATH) VALUES (?,?)',
            [result, imagePath]);
      }
      db.close();
    } else {
      result = await updateContact(contact, image);
    }
    return result;
  }

  Future<int> updateContact(Contact contact, File image) async {
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
    if (image.path != '' && await image.exists()) {
      deleteImageFromDocumentPath(contact.id!.toInt());
      String savedImagePath = await saveImageToDocumentPath(image);
      await db.rawUpdate('UPDATE BLPFPICS SET FULLPATH =? WHERE CONTACTID=?',
          [savedImagePath, contact.id]);
    }
    db.close();

    return result;
  }

  Future<List<Contact>> getAllContacts() async {
    final Database db = await initDb();
    final List<Map<String, Object?>> contactQueryResult = await db.rawQuery(
        "SELECT BLCONTACTS.ID,BLCONTACTS.FIRSTNAME,BLCONTACTS.LASTNAME,BLCONTACTS.EMAIL,BLPFPICS.FULLPATH FROM BLCONTACTS LEFT JOIN BLPFPICS ON BLPFPICS.CONTACTID = BLCONTACTS.ID");

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

  Future<List<Contact>> searchContacts(String searchTerm) async {
    if (searchTerm == '') {
      return getAllContacts();
    } else {
      final Database db = await initDb();

      final List<Map<String, Object?>> contactQueryResult = await db.rawQuery(
          "SELECT BLCONTACTS.ID,BLCONTACTS.FIRSTNAME,BLCONTACTS.LASTNAME,BLCONTACTS.EMAIL,BLPFPICS.FULLPATH FROM BLCONTACTS LEFT JOIN BLPFPICS ON BLPFPICS.CONTACTID = BLCONTACTS.ID"
          " WHERE (FIRSTNAME LIKE '%$searchTerm%' or LASTNAME LIKE '%$searchTerm%')");

      List<Contact> contacts =
          contactQueryResult.map((e) => Contact.fromMap(e)).toList();

      final List<Map<String, Object?>> contactDetailQueryResult =
          await db.query("BLCONTACTSDETAIL");

      List<ContactDetail> detailList = contactDetailQueryResult
          .map((e) => ContactDetail.fromMap(e))
          .toList();

      db.close();

      for (Contact item in contacts) {
        item.contactDetail
            ?.addAll(detailList.where((x) => x.id == item.id).toList());
      }
      if (contacts.isEmpty) {
        contacts = await getAllContacts();
        contacts.retainWhere(
          (x) => x.contactDetail!.any(
            (element) => element.number.contains(searchTerm),
          ),
        );
      }
      return contacts;
    }
  }

  Future<void> deleteContact(int id) async {
    final Database db = await initDb();
    await db.delete('BLCONTACTS', where: "ID=?", whereArgs: [id]);
    await db.delete('BLCONTACTSDETAIL', where: "ID=?", whereArgs: [id]);
    await deleteImageFromDocumentPath(id, deleteTableRecord: true);
    db.close();
  }

  Future<String> saveImageToDocumentPath(File image) async {
    if (image.existsSync()) {
      final docDirectory = await getApplicationDocumentsDirectory();
      final String newName =
          '${docDirectory.path}/${basename(image.path)}${DateTime.now()}';
      final tempFile = await image.rename(newName);

      if (!await tempFile.exists()) {
        await tempFile.copy(newName);
      }
      return tempFile.path;
    }
    return '';
  }

  Future<void> deleteImageFromDocumentPath(int id,
      {bool deleteTableRecord = false}) async {
    final Database db = await initDb();
    final List<Map<String, Object?>> imagePaths =
        await db.query("BLPFPICS", where: "CONTACTID=?", whereArgs: [id]);
    for (var item in imagePaths) {
      String existingPath = item['FULLPATH'].toString();
      if (existingPath != '') {
        if (await File(existingPath).exists()) {
          await File(existingPath).delete();
        }
      }
    }
    if (deleteTableRecord) {
      await db.delete('BLPFPICS', where: "CONTACTID=?", whereArgs: [id]);
    }
    // db.close();
  }
}
