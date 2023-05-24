// import 'package:beacon_app/view/submit_crew/state/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'category.dart';
// import 'crew_list.dart';
// import 'user.dart';
 import 'auth.dart';
// import 'bottom_nav.dart';

// export 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider((ref) => PhoneAuth());

// // 1
// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// // 2
// final authStateChangesProvider = StreamProvider<User?>(
//     (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

// final bottomNavProvider = StateNotifierProvider<NavigationProvider, int>(
//     (ref) => NavigationProvider());

// final userProvider = ChangeNotifierProvider((ref) => UserProvider());

// final crewFormState = ChangeNotifierProvider<CrewFormState>((ref) {
//   final _imagePickerClass = ref.watch(imageProvier);
//   return CrewFormState(_imagePickerClass, ref);
// });

// final imageProvier = ChangeNotifierProvider((ref) => ImageClass());

// final categoryProvider = ChangeNotifierProvider((ref) => CategoryProvider());

// final crewListProvider = ChangeNotifierProvider((ref) => CrewListProvider());
