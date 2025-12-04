class SessionException implements Exception {
  final String _message;
  final String _description;
  SessionException(this._message, this._description);
  @override
  String toString() {
    String result = 'Session Error';
    return '$result: $_message';
  }

  String get description => _description;
  String get message => _message;
}
