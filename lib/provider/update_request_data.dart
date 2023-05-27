import 'package:flutter/foundation.dart';
import 'package:testapp/services/firebase_api.dart';

class UpdateRequestProvider extends ChangeNotifier {
  String get message => _message;
  UpdateStatus get status => _status;

  UpdateStatus _status = UpdateStatus.initilize;
  String _message = '';

  Future<void> updateData(Map<String, String> data) async {
    try {
      changeStatus(UpdateStatus.loading);
      await FirbaseApi().updateUserRequest(data);
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
