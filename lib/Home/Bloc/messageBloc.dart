import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kyahaal/Home/Modals/messages.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> localdb;
String myUid = FirebaseAuth.instance.currentUser.uid;
FirebaseDatabase _database = FirebaseDatabase.instance;

listentoIncomingMessage(String uid, MessageBloc bloc) {
  DatabaseReference _messageRef =
      _database.reference().child("$myUid/messages/$uid");
  _messageRef.onChildAdded.listen(
    (event) {
      Map<String, dynamic> message =
          Map<String, dynamic>.from(event.snapshot.value);
      Messages messages = Messages.fromJson(message);
      bloc
          .insert(messages)
          .whenComplete(() => _messageRef.child(messages.pushId).remove());
    },
  );
  _messageRef.child("isTyping").onValue.listen((event) {
    bloc.revertWhetherTyping(event);
  });
}

listentoOutgoingMessage(String uid, MessageBloc bloc) {
  DatabaseReference _messageRef =
      _database.reference().child("$uid/messages/$myUid");
  _messageRef.onChildAdded.listen(
    (event) {
      Map<String, dynamic> message =
          Map<String, dynamic>.from(event.snapshot.value);
      Messages messages = Messages.fromJson(message);
      bloc.insert(messages);
      //.whenComplete(() => _messageRef.child(messages.pushId).remove());
    },
  );
}

setupDatabase() async {
  String path = join(await getDatabasesPath(), 'messages.db');
  localdb = openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE messages(pushId TEXT PRIMARY KEY, message TEXT, sentBy TEXT, sentTo TEXT, timeStamp int,read bool)",
      );
    },
    version: 1,
  );
}

Future<void> addMessage(Messages message) async {
  var data = message.toJson();
  final Database db = await localdb;
  db.insert(
    "messages",
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
    nullColumnHack: "Unknown",
  );
}

Future<List<Messages>> getMessages(String uid) async {
  if (localdb != null) {
    final Database db = await localdb;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: "(sentBy=? AND sentTo=?) OR (sentBY=? AND sentTo=?)",
      whereArgs: [
        uid,
        myUid,
        myUid,
        uid,
      ],
      orderBy: "timeStamp",
    );
    return List.generate(
      maps.length,
      (i) {
        return Messages.fromJson(maps[i]);
      },
    );
  }
  return [];
}

sendMessage(Messages message) {
  DatabaseReference _messageRef =
      _database.reference().child("${message.sentTo}/messages/$myUid");
  var pushId = _messageRef.push().key;
  message.pushId = pushId;
  message.read = true;
  message.sentBy = myUid;
  message.timeStamp = ServerValue.timestamp;
  _messageRef.child(pushId).set(message.toJson());
}

class MessageBloc {
  final String uid;
  MessageBloc({this.uid}) {
    getBlocMessages(uid);
  }
  final messageController = StreamController<List<Messages>>.broadcast();
  final isTypingController = StreamController<bool>.broadcast();

  getBlocMessages(String uid) async {
    messageController.sink.add(await getMessages(uid));
  }

  insert(Messages message) async {
    await addMessage(message);
    await getBlocMessages(uid);
  }

  sendBlocMessages(Messages message) async {
    await sendMessage(message);
    //await insert(message);
  }

  revertWhetherTyping(dynamic value) {
    if (value == 1) {
      isTypingController.sink.add(true);
    } else {
      isTypingController.sink.add(false);
    }
  }

  addWhetherTyping(bool isTyping) {
    DatabaseReference _messageRef =
        _database.reference().child("$uid/messages/$myUid/isTyping");
    _messageRef.set(isTyping);
  }

  dispose() {
    messageController.close();
    isTypingController.close();
  }
}
