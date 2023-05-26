import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/provider/get_user_data.dart';
import 'package:testapp/provider/update_user_data.dart';
import 'auth.dart';

final authProvider = ChangeNotifierProvider((ref) => PhoneAuth());
final userProvider = ChangeNotifierProvider((ref) => UserProvider());
final updateUserProvider =
    ChangeNotifierProvider((ref) => UpdateUserProvider());
