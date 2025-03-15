import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  /// Singleton class

  NotesDatabase._();
  static final String tableName = "Notes";
  static final String columnNo = "s_no";
  static final String columnTitle = "title";
  static final String columnDescription = "description";

  static final NotesDatabase getInstance = NotesDatabase._();

  Database? myDB;

  //  Open database if exist, else create it
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "notesDatabase.db");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        //create schema
        db.execute(
          "CREATE TABLE $tableName ($columnNo INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT)",
        );
      },
      version: 1,
    );
  }

  // Adding notes to the database
  Future<bool> addNote({required String myTitle, required String myDes}) async {
    var db = await getDB();

    int rowsEffected = await db.insert(tableName, {
      columnTitle: myTitle,
      columnDescription: myDes,
    });
    return rowsEffected > 0;
  }

  // getting all the notes from the notesDatabase
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    /// Select * from notesDatabase
    List<Map<String, dynamic>> mData = await db.query(tableName);
    return mData;
  }

  // Update notes

  Future<bool> updateNotes({
    required String myTitle,
    required String myDes,
    required int sno,
  }) async {
    var db = await getDB();

    int rowsEffected = await db.update(tableName, {
      columnTitle: myTitle,
      columnDescription: myDes,
    }, where: "$columnNo = $sno");

    return rowsEffected > 0;
  }

  // delete notes
  Future<bool> deleteNotes({required int sno}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(
      tableName,
      where: "$columnNo= ? ",
      whereArgs: ['$sno'],
    );
    return rowsEffected > 0;
  }
}
