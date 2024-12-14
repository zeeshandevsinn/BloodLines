import 'package:bloodlines/View/Chat/database/initDb.dart';
import 'package:sqflite/sqflite.dart';

 class DatabaseBaseConfig {
  Future<Database> initDatabase() {
    // TODO: implement initDatabase
    throw UnimplementedError();
  }
}
 class DatabaseBaseConfigs {
  Future<Database> initDatabase() {
    // TODO: implement initDatabase
    throw UnimplementedError();
  }
}

class ChatDatabase implements DatabaseBaseConfig, DatabaseBaseConfigs{
  static final ChatDatabase chatSingletonClass = ChatDatabase._internal();

  factory ChatDatabase() {
    return chatSingletonClass;
  }

  Future<Database> get getDatabase {
    return initDatabase();
  }

  @override
  Future<Database> initDatabase() async {
    final path = await initDeleteDb('chat.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS Chat(id INTEGER PRIMARY KEY, sender_id INTEGER, receiver_id INTEGER, parent_id INTEGER, is_flagged INTEGER, conversation_id TEXT, message TEXT, is_seen INTEGER, parent_chat TEXT, file_type TEXT, is_deleted INTEGER, media TEXT, delete_by INTEGER, created_at TEXT, updated_at TEXT, user TEXT, is_user_deleted INTEGER)',
        );
      },
      version: 1,
    );
  }

  ChatDatabase._internal();
}
