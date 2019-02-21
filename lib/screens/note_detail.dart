import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_check_list/models/note.dart';
import 'package:my_check_list/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() => NoteDetailState(this.note, this.appBarTitle);
}

class NoteDetailState extends State<NoteDetail> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                moveToLastScreen();
          }),
          title: Text(appBarTitle),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: titleController,
                    style: textStyle,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter title';
                      }else {
                        print('Something changed in Title Text Field $value');
                        updateTitle();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: descriptionController,
                    style: textStyle,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter description';
                      }else {
                        print('Something changed in Description Text Field $value');
                        updateDescription();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Save', textScaleFactor: 1.5,),
                            onPressed: (){
                              setState(() {
                                print('Save button clicked');
                                if (_formKey.currentState.validate()) {
                                  _save();
                                }
                              });
                            },
                      )
                      ),
                      Container(width: 5.0),
                      Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Delete', textScaleFactor: 1.5,),
                            onPressed: (){
                              setState(() {
                                print('Delete button clicked');
                                _delete();
                              });
                            },
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {

    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // 更新
      result = await helper.updateNote(note);
    }else {
      // 新增
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // 成功
      _showAlertDialog('Note saved successfully');
    }else {
      // 失敗
      _showAlertDialog('Error');
    }
  }

  void _delete() async {

    moveToLastScreen();

    if (note.id == null) {
      // 刪除新的資料
      _showAlertDialog('No Note was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      // 成功
      _showAlertDialog('Note saved successfully');
    }else {
      // 失敗
      _showAlertDialog('Error');
    }
  }

  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(title: Text(''), content: Text(message),);
    showDialog(context: context, builder: (_) => alertDialog);
  }
 }
