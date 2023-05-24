// import 'dart:convert';
// import 'dart:developer';

// import 'package:beacon_app/model/user.dart';
// import 'package:flutter/foundation.dart';

// import '../config/app_constants.dart';
// import '../services/firebase_api.dart';
// import '../services/secure_storage.dart';

// class UserProvider extends ChangeNotifier {
//   bool _hasActivePlan = false;
//   bool get hasActivePlan => _hasActivePlan;

//   Map<String, dynamic>? _userFullData;
//   Map<String, dynamic>? get userFullData => _userFullData;

//   Future<void> fetchSubscriptionDetails({bool forceUpdate = false}) async {
//     // Map<String, dynamic>? _user;
//     try {
//       _userFullData = await readSubscribedDate();

//       // If save subscription date is empty read plan from firebase
//       if (_userFullData == null || forceUpdate) {
//         _userFullData = await FirbaseApi().getUserData();

//         // save user data
//         if (_userFullData != null) {
//           _userFullData!.remove('created_at');
//           saveUserData(_userFullData!);
//         }
//       }
//       checkForProMembership(_userFullData?[AppConfig.currentPlan]);

//       notifyListeners();
//     } catch (e) {
//       _hasActivePlan = false;
//       notifyListeners();

//       log(e.toString());
//     }
//   }

//   checkForProMembership(Map<String, dynamic>? _planObject) async {
//     final _currenDate = DateTime.now();
//     if (_planObject != null) {
//       final _expDate = DateTime.parse(_planObject['purchased_on']).add(Duration(days: _planObject['duration']));

//       // fetch subscription details form firebase if current plan expired
//       // in case if user has purchased a new plan
//       if (_currenDate.isAfter(_expDate)) {
//         _userFullData = await FirbaseApi().getUserData();
//         _planObject = _userFullData?[AppConfig.currentPlan];
//       }

//       _hasActivePlan = _currenDate.isBefore(_expDate);
//     } else {
//       _hasActivePlan = false;
//     }
//   }

//   bool hasListingToken() {
//     bool _status = false;
//     if (_userFullData?['plans']?.isNotEmpty ?? false) {
//       for (final i in _userFullData!['plans']) {
//         if (i['used'] == false) {
//           _status = true;
//           return _status;
//         }
//       }
//     }
//     return _status;
//   }

//   void deletePlan() {
//     StorageService().deleteString('user');
//     _hasActivePlan = false;
//     notifyListeners();
//   }

//   void saveUserData(Map<String, dynamic> data) {
//     final _string = json.encode(data);
//     StorageService().saveString('user', _string);
//   }

//   Future<Map<String, dynamic>?> readSubscribedDate() async {
//     final _data = await StorageService().readString('user');
//     if (_data == null) return null;

//     return json.decode(_data) as Map<String, dynamic>;
//   }

//   // *
//   Future<void> getSavedFilimIndustry() async {
//     final _value = await StorageService().readString('film_industry');
//     UserData().filmIndustry = int.tryParse(_value.toString());
//   }

//   Future<void> savedFilimIndustry(String value) async {
//     await StorageService().saveString('film_industry', value);
//     UserData().filmIndustry = int.parse(value);
//   }
// }
