import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/database_helper.dart';
import '../models/note.dart';
class NoteProvider with ChangeNotifier {
  List _items = [];
  List get items {
    return [..._items];
  }
  Future getNotes() async {
    final notesList = await DatabaseHelper.getNotesFromDB();
    _items = notesList
        .map(
          (item) =>
          Note(
              item['id'], item['title'], item['content'], item['imagePath']),
    )
        .toList();
    notifyListeners();
    @override
    Widget build(BuildContext context) {
      return FutureBuilder(
        future: Provider.of<NoteProvider>(context,listen: false).getNotes(),
        builder: (context,snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else
          {
            if(snapshot.connectionState == ConnectionState.done)
            {
              return Scaffold(
                body: Consumer<NoteProvider>(
                  child: noNotesUI(context),
                  builder: (context, noteprovider, child) =>
                  noteprovider.items.length <= 0
                      ? child
                      : Container(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    goToNoteEditScreen(context);
                  },
                  child: Icon(Icons.add),
                ),
              );
            }
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }
        },
      );
    }
  }
}