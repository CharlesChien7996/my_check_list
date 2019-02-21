import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_check_list/models/note.dart';
import 'package:my_check_list/utils/database_helper.dart';
import 'package:my_check_list/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Check List')),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB clicked');
          navigateToDetail(
              Note(id: null, title: '', description: '', date: ''), 'Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
//            leading: CircleAvatar(
//              backgroundColor: Colors.yellowAccent,
//              child: Icon(Icons.arrow_right),
//            ),
            title: Text(this.noteList[index].title, style: titleStyle,),
            subtitle: Text(this.noteList[index].date,),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, this.noteList[index]);
              },
            ),
            onTap: () {
              print('item tapped');
              navigateToDetail(this.noteList[index], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    // 顯示訊息
    if (result != 0) {
      _showSnackBar(context, 'Note deleted successfully');
      // 更新畫面
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> databaseFuture = databaseHelper.initializeDatabase();
    databaseFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}