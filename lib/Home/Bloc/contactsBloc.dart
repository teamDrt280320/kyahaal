import 'dart:async';

import 'package:kyahaal/Home/Modals/khuser.dart';
import 'package:kyahaal/Home/Modals/localDbKhuser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> localdb;

setupDatabase() async {
  String path = join(await getDatabasesPath(), 'contacts.db');
  localdb = openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE contacts(uid TEXT PRIMARY KEY, khname TEXT, dpurl TEXT, number TEXT, devicename Text)",
      );
    },
    version: 1,
  );
}

addContact(KHUser user, {String name}) async {
  Map<String, dynamic> data = {
    "uid": user.uid,
    "khname": user.username,
    "dpurl": user.photo,
    "number": user.number,
    "devicename": name ?? user.number,
  };
  final Database db = await localdb;
  db.insert(
    "contacts",
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
    nullColumnHack: "Unknown",
  );
}

getUsers() async {
  final Database db = await localdb;
  final List<Map<String, dynamic>> maps = await db.query(
    'contacts',
    orderBy: "devicename",
  );
  return List.generate(
    maps.length,
    (i) {
      return LocalKhUser.fromJson(maps[i]);
    },
  );
}

class ContactsBloc {
  final loadingController = StreamController<bool>.broadcast();
  final contactsController = StreamController<List<LocalKhUser>>.broadcast();

  getContacts() async {
    if (!loadingController.isClosed) {
      loadingController.sink.add(true);
    }
    var con = await getUsers();
    if (!loadingController.isClosed) {
      loadingController.sink.add(false);
    }
    if (!contactsController.isClosed) {
      contactsController.sink.add(con);
    }
  }

  insert(KHUser user, {String name}) async {
    await addContact(user, name: name);
    await getContacts();
  }

  void dispose() {
    loadingController.close();
    contactsController.close();
  }
}
