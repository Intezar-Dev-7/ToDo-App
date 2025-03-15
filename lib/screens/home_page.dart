import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/db_functions.dart';
import 'package:to_do_app/provider/db_provider.dart';
import 'package:to_do_app/screens/add_note_page.dart';
import 'package:to_do_app/screens/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Map<String, dynamic>> allNotes = [];

  // NotesDatabase? dbRef = NotesDatabase.getInstance;

  @override
  void initState() {
    context.read<DBProvider>().getInitialNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),

        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 11),
                      Text('Settings'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),

      body: Consumer<DBProvider>(
        builder: (cts, provider, __) {
          List<Map<String, dynamic>> allNotes = provider.getNotes();
          return allNotes.isNotEmpty
              ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      allNotes[index][NotesDatabase.columnTitle],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      allNotes[index][NotesDatabase.columnDescription],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 105,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AddNotePage(
                                          isUpdate: true,
                                          title:
                                              allNotes[index][NotesDatabase
                                                  .columnTitle],
                                          desc:
                                              allNotes[index][NotesDatabase
                                                  .columnDescription],
                                          sno:
                                              allNotes[index][NotesDatabase
                                                  .columnNo],
                                        ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                // size: 10,
                              ),
                              onPressed: () async {
                                Provider.of<DBProvider>(
                                  context,
                                  listen: false,
                                ).deleteNote(
                                  allNotes[index][NotesDatabase.columnNo],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
              : Center(
                child: Text("No notes !!", style: TextStyle(fontSize: 20)),
              );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
