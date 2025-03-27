import 'dart:io'; // Importing dart:io to work with file system operations
import 'package:path/path.dart'; // Provides utilities for manipulating file paths
import 'package:path_provider/path_provider.dart'; // Used to get application-specific directories
import 'package:sqflite/sqflite.dart'; // SQFlite package to work with SQLite databases in Flutter

/// A singleton class that manages the SQLite database for storing notes
class NotesDatabase {
  // Private named constructor to ensure this class follows the singleton pattern
  NotesDatabase._();

  // Table and column names as constants
  static final String tableName = "Notes"; // Table name
  static final String columnNo = "s_no"; // Primary key column
  static final String columnTitle = "title"; // Column for note title
  static final String columnDescription = "description"; // Column for note description

  // Singleton instance of the database class
  static final NotesDatabase getInstance = NotesDatabase._();

  // Database instance (nullable)
  Database? myDB;

  /// Opens the database if it exists, otherwise creates a new one
  Future<Database> getDB() async {
    // If the database instance is already open, return it
    myDB ??= await openDB();
    return myDB!;
  }

  /// Function to open or create the database
  Future<Database> openDB() async {
    // Get the application documents directory (where the database will be stored)
    Directory appDir = await getApplicationDocumentsDirectory();

    // Define the database path
    String dbPath = join(appDir.path, "notesDatabase.db");

    // Open the database and define its structure if it's newly created
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        // Create table schema when the database is first created
        db.execute(
          "CREATE TABLE $tableName ($columnNo INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT)",
        );
      },
      version: 1, // Database version
    );
  }

  /// Function to add a new note to the database
  Future<bool> addNote({required String myTitle, required String myDes}) async {
    var db = await getDB(); // Get database instance

    // Insert new note into the table
    int rowsEffected = await db.insert(tableName, {
      columnTitle: myTitle,
      columnDescription: myDes,
    });

    // If rowsEffected > 0, note was successfully added
    return rowsEffected > 0;
  }

  /// Function to retrieve all notes from the database
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB(); // Get database instance

    // Select all notes from the table
    List<Map<String, dynamic>> mData = await db.query(tableName);
    return mData;
  }

  /// Function to update a note in the database
  Future<bool> updateNotes({
    required String myTitle,
    required String myDes,
    required int sno, // Note ID to update
  }) async {
    var db = await getDB(); // Get database instance

    // Update note where `s_no` matches the given ID
    int rowsEffected = await db.update(tableName, {
      columnTitle: myTitle,
      columnDescription: myDes,
    }, where: "$columnNo = $sno");

    return rowsEffected > 0; // Returns true if update was successful
  }

  /// Function to delete a note from the database
  Future<bool> deleteNotes({required int sno}) async {
    var db = await getDB(); // Get database instance

    // Delete note where `s_no` matches the given ID
    int rowsEffected = await db.delete(
      tableName,
      where: "$columnNo= ? ",
      whereArgs: ['$sno'], // Secure way to prevent SQL injection
    );

    return rowsEffected > 0; // Returns true if deletion was successful
  }
}

