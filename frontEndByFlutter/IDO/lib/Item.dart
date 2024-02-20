import 'dart:ui';

class Item {
  int _id;
  String _title;
  String _category;
  int _statusId;
  DateTime? dueDate;
  int _importance;
  String estimatedText;
  int _userId;
  int ?_estimated;
  Color _color = Color(0xFF212529);



  Item(this._id, this._title, this._category, this._statusId, this.dueDate,
      this._importance, this._userId, this._estimated , this.estimatedText);

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  int get importance => _importance;

  set importance(int value) {
    _importance = value;
  }

  int get statusId => _statusId;

  set statusId(int value) {
    _statusId = value;
  }

  String get categoryId => _category;

  set categoryId(String value) {
    _category = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int? get Estimated => _estimated;

  set estimated(int value) {
    _estimated = value;
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }
}

List<Item> items = [

];
