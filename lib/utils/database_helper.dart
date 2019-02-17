import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_check_list/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String id = 'id';
  String title = 'title';
  String description = 'description';
  String date = 'date';

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

  Future<Database> initializeDatabase() async {
    // 取得資料路徑
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.database';

    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database database, int newVersion) async{
    await database.execute('CREATE TABLE $noteTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $description TEXT, $date TEXT)');
  }

  // 查詢
  Future<List<Note>> getNoteList() async{
    Database database = await this.database;
//    var result = database.rawQuery('SELECT * FROM $noteTable order by $date ASC'); 同下
    var result = await database.query(noteTable, orderBy: '$date ASC');
    var count = result.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(result[i]));
    }
    return noteList;
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
    var result = await database.rawDelete('DELETE FROM $noteTable WHERE $this.id = $id');
    return result;
  }
  // 修改
  Future<int> updateNote(Note note) async {
    Database database = await this.database;
    var result = await database.update(noteTable, note.toMap(), where: '$id = ?', whereArgs: [note.id]);
    return result;
  }

  // 取得資料庫筆數
  Future<int> getListCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> noteList = await database.rawQuery('SELECT COUNT * FROM $noteTable');
    int result = Sqflite.firstIntValue(noteList);
    return result;
  }
}