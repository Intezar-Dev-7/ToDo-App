import 'package:flutter/material.dart';
import 'package:to_do_app/services/db_functions.dart';

class DBProvider extends ChangeNotifier {
  NotesDatabase notesDatabase;
  DBProvider({required this.notesDatabase});
  List<Map<String, dynamic>> _mData = [];

  // Events

  void addNote(String title, String desc) async {
    bool check = await notesDatabase.addNote(myTitle: title, myDes: desc);
    if (check) {
      _mData = await notesDatabase.getAllNotes();
      notifyListeners();
    }
  }

  void updateNote(String title, String desc, int sno) async {
    bool check = await notesDatabase.updateNotes(
      myTitle: title,
      myDes: desc,
      sno: sno,
    );
    if (check) {
      _mData = await notesDatabase.getAllNotes();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getNotes() => _mData;

  void getInitialNotes() async {
    _mData = await notesDatabase.getAllNotes();
    notifyListeners();
  }

  void deleteNote(int sno) async {
    bool check = await notesDatabase.deleteNotes(sno: sno);
    if (check) {
      _mData = await notesDatabase.getAllNotes();

      notifyListeners();
    }
  }
}
