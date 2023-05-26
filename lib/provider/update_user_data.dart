import 'package:flutter/foundation.dart';
import 'package:testapp/services/firebase_api.dart';

class UpdateUserProvider extends ChangeNotifier {
  String get message => _message;
  UpdateStatus get status => _status;

  UpdateStatus _status = UpdateStatus.initilize;
  String _message = '';

  Future<void> updateUserData(Map<String, String> data) async {
    try {
      changeStatus(UpdateStatus.loading);
      await FirbaseApi().updateUser(data);
      changeStatus(UpdateStatus.success);
    } catch (e) {
      _message = e.toString();
      changeStatus(UpdateStatus.error);
    }
  }

  void changeStatus(UpdateStatus sts) {
    _status = sts;
    notifyListeners();
  }
}

enum UpdateStatus { success, error, loading, initilize }
