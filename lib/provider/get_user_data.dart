import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/services/firebase_api.dart';
import 'package:testapp/services/secure_storage.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> get userData => _userFullData;
  String get message => _message;
  UserStatus get status => _status;

  UserStatus _status = UserStatus.initilize;
  String _message = '';
  Map<String, dynamic> _userFullData = {};

  AuthState _state = AuthState.initialize;
  AuthState get state => _state;

  List<UserModel> _usermodel = [];
  List<UserModel> get usermodel => _usermodel;

  UserListStatus get userliststatus => _userliststatus;

  UserListStatus _userliststatus = UserListStatus.initilize;

  Future<void> getUserData(String documentId) async {
    try {
      _userFullData = await FirbaseApi().getUserData(documentId);
      saveUserData(_userFullData);

      changeStatus(UserStatus.success);
    } catch (e) {
      _message = e.toString();
      changeStatus(UserStatus.error);
    }
  }

  Future<void> getUserList() async {
    try {
      _usermodel = await FirbaseApi().getUserList(_userFullData['mobile']);

      changeuserListStatus(UserListStatus.success);
    } catch (e) {
      _message = e.toString();
      changeuserListStatus(UserListStatus.error);
    }
  }

  void saveUserData(Map<String, dynamic> data) {
    final _string = json.encode(data);
    StorageService().saveString('user', _string);
  }

  readUserData() async {
    String? _string = await StorageService().readString('user');
    if (_string != null) {
      if (_string.isNotEmpty) {
        _userFullData = json.decode(_string);
        changeAuthStatus(AuthState.authenticated);
      } else {
        changeAuthStatus(AuthState.unauthenticated);
      }
    } else {
      changeAuthStatus(AuthState.unauthenticated);
    }
  }

  void changeStatus(UserStatus sts) {
    _status = sts;
    notifyListeners();
  }

  void changeAuthStatus(AuthState sts) {
    _state = sts;
    notifyListeners();
  }

  void changeuserListStatus(UserListStatus sts) {
    _userliststatus = sts;
    notifyListeners();
  }
}

enum UserStatus { success, error, initilize }

enum UserListStatus { success, error, initilize }

enum AuthState { initialize, authenticated, unauthenticated }
