import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

dynamic database;

// initialise database
Future<Database> databaseint() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "pnews.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE userquerys(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    query TEXT,         
                )''');
    },
  );
  return database;
}

// information class [ sarv app chi information assess karanyat madat karel]
class UserInfo {
  static UserInfo obj = UserInfo();
  var database;

  UserInfo() {
    getDatabase();
  }

  Future<void> getDatabase() async {
    database = await databaseint();
  }

// To return the single obbject of the class(single tan desine patten)
// if we create a new object each time database not get initialise for that object and we get null database error
  static UserInfo getObject() {
    return obj;
  }

  Future<bool> isQueryExixt(String query) async {
    final localDB = await database;
    var preQueryList = await localDB.query(
      "userquerys",
      {"query": query},
      where: "query = ?",
      whereArgs: [query],
    );

    if (preQueryList.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> removeQueryIfExit(String query) async {
    if (await isQueryExixt(query)) {
      final localDB = await database;
      localDB.delete(
        'userquerys',
        {"query": query},
        where: "query=?",
        whereArgs: [query],
      );
    }
  }

  Future<void> insertNewQuery(String newSearchQuery) async {
    // await getDatabase();
    //await getUserSearchHistory();
    final localDB = await database;
    await removeQueryIfExit(newSearchQuery);

    localDB.insert(
      'userquerys',
      {"query": newSearchQuery},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //  get User Search History
  Future<List> getUserSearchHistory() async {
    await getDatabase();
    final localDB = await database;
    var user = await localDB.query("userquerys");
    return user;
  }
}
