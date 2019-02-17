class Note {
  int _id;
  String _title;
  String _description;
  String _date;

  Note({int id, String title, String description, String date}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._date = date;
  }

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  set title(String newTitle){
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription){
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set date(String newDate){
    this._date = newDate;
  }
  // 將物件轉換成 Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['title'] = this._title;
    map['description'] = this._description;
    map['date'] = this._date;

    return map;
  }

  // 將 Map 轉換成物件
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
