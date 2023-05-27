import 'package:flutter/foundation.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/services/firebase_api.dart';

class RequestsProvider extends ChangeNotifier {
  String get message => _message;

  RequestStatus _status = RequestStatus.initilize;
  String _message = '';

  List<UserModel> _usermodel = [];
  List<UserModel> get usermodel => _usermodel;

  RequestStatus get status => _status;

  Future<void> getRequests(String documentId) async {
    try {
      _usermodel = await FirbaseApi().getRequestUserList(documentId);

      changeStatus(RequestStatus.success);
    } catch (e) {
      _message = e.toString();
      changeStatus(RequestStatus.error);
    }
  }

  void changeStatus(RequestStatus sts) {
    _status = sts;
    notifyListeners();
  }
}

enum RequestStatus { success, error, initilize }
