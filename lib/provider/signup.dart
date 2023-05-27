import 'package:flutter/foundation.dart';
import 'package:testapp/services/firebase_api.dart';

class SignupProvider extends ChangeNotifier {
  String get message => _message;
  Status get status => _status;

  Status _status = Status.initilize;
  String _message = '';

  Future<void> signup(Map<String, String> data) async {
    try {
      changeStatus(Status.loading);
      await FirbaseApi().createUser(data);
      changeStatus(Status.success);
    } catch (e) {
      _message = e.toString();
      changeStatus(Status.error);
    }
  }

  void changeStatus(Status sts) {
    _status = sts;
    notifyListeners();
  }
}

enum Status { success, error, loading, initilize }
