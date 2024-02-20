class User {
  String _email;

  String _pass;

  String _img;

  User(this._email, this._pass, this._img);

  String get pass => _pass;

  String get email => _email;

  String get img => _img;

  set img(String value) {
    _img = value;
  }
}
