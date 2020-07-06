import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todomobx/models/todo_model.dart';
import 'package:todomobx/stores/todo_store.dart';

class DbService {
  // torna esta classe singleton
  DbService._privateConstructor();
  static final DbService instance = DbService._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "todos_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, done BOOLEAN NOT NULL CHECK (done IN (0,1)))");
    });
  }

  Future<void> insert(TodoNote todo) async {
    final Database _db = await database;

    await _db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> todoNotes() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    List<TodoStore> listContact = List();
    for(Map m in maps){
      TodoStore todo = TodoStore(TodoNote.fromMap(m));
      todo.done = TodoNote.fromMap(m).done == 1 ? true : false;
      listContact.add(todo);
    }

    return listContact;
  }

  Future<void> update(TodoNote todo) async {
    final Database db = await database;

    await db.update(
      'todos',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
