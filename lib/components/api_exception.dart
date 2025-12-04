class APIException implements Exception {
  final String _message;
  final String _description;
  APIException(this._message, this._description);
  @override
  String toString() {
    String result = 'Api Error';
    return '$result: $_message';
  }

  String get description => _description;
  String get message => _message;
}
