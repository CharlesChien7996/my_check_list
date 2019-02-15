import 'package:flutter/material.dart';
import 'package:my_check_list/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'my_check-list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueAccent[300],
      ),
      home: NoteList(),
    );
  }
}
