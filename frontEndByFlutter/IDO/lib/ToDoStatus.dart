class ToDoStatus {
  int _id;
  String _status;
  String _img;

  ToDoStatus(this._id, this._status, this._img);

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
