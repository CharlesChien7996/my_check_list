import 'package:flutter/material.dart';
import 'package:my_check_list/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  int count = 20;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Check List')),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB clicked');
          navigateToDetail('Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          child: ListTile(
//            leading: CircleAvatar(
//              backgroundColor: Colors.yellowAccent,
//              child: Icon(Icons.arrow_right),
//            ),
            title: Text('Title'),
            subtitle: Text('Date'),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              print('item tapped');
              navigateToDetail('Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(title);
    }));
  }

}
