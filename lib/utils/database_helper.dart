import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_check_list/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

//  static Future<String> initDb(String dbName) async {
//    String path = join(databasePath, dbName);
//    if (await Directory(dirname(path)).exists()) {
//    } else {
//      try {
//        await Directory(dirname(path)).create(recursive: true);
//      } catch (e) {
//        print(e);
//      }
//    }
//    return path;
//  }

  Future<Database> initializeDatabase() async {
    // 取得資料路徑
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.database');

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database database, int newVersion) async{
    await database.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colDate TEXT)');
  }

  // 查詢
  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database database = await this.database;
//    var result = database.rawQuery('SELECT * FROM $noteTable order by $date ASC'); 同下
    var result = await database.query(noteTable, orderBy: '$colDate ASC');
    return result;
  }

  // 新增
  Future<int> insertNote(Note note) async {
    Database database = await this.database;
    var result = await database.insert(noteTable, note.toMap());
    return result;
  }
  // 刪除
  Future<int> deleteNote(int id) async {
    Database database = await this.database;
    var result = await database.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  // 修改
  Future<int> updateNote(Note note) async {
    Database database = await this.database;
    var result = await database.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // 取得資料庫筆數
  Future<int> getListCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> noteList = await database.rawQuery('SELECT COUNT * FROM $noteTable');
    int result = Sqflite.firstIntValue(noteList);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
}
}