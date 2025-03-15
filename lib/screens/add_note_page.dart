import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:to_do_app/provider/db_provider.dart';

class AddNotePage extends StatelessWidget {
  AddNotePage({
    super.key,
    this.isUpdate = false,
    this.sno = 0,
    this.title = "",
    this.desc = "",
  });
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];

  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  bool isUpdate;
  String title;
  String desc;
  int sno;

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      titleController.text = title;
      descriptionController.text = desc;
    }
    return Scaffold(
      appBar: AppBar(title: Text(isUpdate ? 'Update Note' : 'Add note')),
      body: Container(
        padding: EdgeInsets.all(11),

        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 21),
            TextField(
              focusNode: titleFocus,
              textInputAction: TextInputAction.next,
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
                label: Text('Title'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            SizedBox(height: 15),
            TextField(
              focusNode: descriptionFocus,
              textInputAction: TextInputAction.next,
              maxLines: 4,
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter Description",
                label: Text('Description'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    onPressed: () async {
                      String errorMessage =
                          "Title and description cannot be empty";
                      var title = titleController.text;
                      var description = descriptionController.text;
                      if (title.isNotEmpty && description.isNotEmpty) {
                        if (isUpdate) {
                          context.read<DBProvider>().updateNote(
                            title,
                            desc,
                            sno,
                          );
                        } else {
                          context.read<DBProvider>().addNote(title, desc);
                        }
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(errorMessage)));
                      }
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },

                    child: Text(isUpdate ? 'Update' : 'Save'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
