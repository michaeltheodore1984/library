import 'package:sqflite/sqflite.dart';

class Db {
  static var db = 'main.db';
  static var conversation = 'Conversation';

  static scaffold() async {
    await openDatabase(db, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $conversation (
        _id integer primary key autoincrement,
        message text not null,
        isImage integer,
        CONSTRAINT unique_message UNIQUE (message)
      )''');
    });
  }

  static Future<Database> open() async {
    return await openDatabase(db);
  }

  // Add a message to Sqflite by using a transaction.
  static void addMessage(Message m) async {
    var db = await open();
    await db.transaction((txn) async {
      await txn.insert(conversation, m.toMap());
    });
  }
}

// The Message object.
class Message {
  String message = 'def_message';
  int isImage = 0;

  // Need toMap() to insert as key value pairs into Sqflite.
  Map<String, Object> toMap() {
    return {'message': message};
  }

  // Read message from database key value pairs.
  Message.fromMap(Map<String, Object> map) {
    message = map['message'] as String;
    isImage = map['isImage'] as int;
  }
}
