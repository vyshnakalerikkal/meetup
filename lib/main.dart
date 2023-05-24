
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/theme/styles.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/palette.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
   await Firebase.initializeApp();
   runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetUp',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        textTheme: textTheme,
      ),
      onGenerateRoute: generateRoute,
    );
  }
}

class AppInit extends ConsumerStatefulWidget {
  const AppInit({Key? key}) : super(key: key);

  @override
  ConsumerState<AppInit> createState() => _AppInitState();
}

class _AppInitState extends ConsumerState<AppInit> {
 

  @override
  void initState() {
 
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: SplashScreen(),
          ),
       
    );
  }

  // Widget curretnScreen(AuthState state, bool isUserSet) {
  //   switch (state) {
  //     case AuthState.initialize:
  //       return const SplashScreen();
  //     case AuthState.authenticated:
  //       // return isUserSet ? const ProfileScreen() : const SetupProfileScreen();
  //       return const ProfileScreen();
  //     case AuthState.unauthenticated:
  //       return const OnboardScreen();
  //     default:
  //       return const SplashScreen();
  //   }
  // }
}
