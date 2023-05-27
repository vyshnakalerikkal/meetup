import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/provider/get_purchase_data.dart';
import 'package:testapp/provider/get_requests_data.dart';
import 'package:testapp/provider/get_user_data.dart';
import 'package:testapp/provider/signup.dart';
import 'package:testapp/provider/update_request_data.dart';
import 'package:testapp/provider/update_user_data.dart';
import 'auth.dart';

final authProvider = ChangeNotifierProvider((ref) => PhoneAuth());
final signupProvider = ChangeNotifierProvider((ref) => SignupProvider());
final userProvider = ChangeNotifierProvider((ref) => UserProvider());
final updateUserProvider =
    ChangeNotifierProvider((ref) => UpdateUserProvider());

final purchaseprovider = ChangeNotifierProvider((ref) => PurchaseProvider());
final requestprovider = ChangeNotifierProvider((ref) => RequestsProvider());
final updateRequestProvider =
    ChangeNotifierProvider((ref) => UpdateRequestProvider());
