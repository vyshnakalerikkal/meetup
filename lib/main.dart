import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/provider/get_user_data.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/screens/dashboard/bottom_navigation.dart';
import 'package:testapp/screens/onboard/onboard_screen.dart';
import 'package:testapp/screens/splash/splash_screen.dart';
import 'package:testapp/theme/styles.dart';
import 'theme/palette.dart';

void main() async {
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
    ref.read(userProvider).readUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Consumer(
          builder: (_, ref, __) {
            final data = ref.watch(userProvider);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: curretnScreen(data.state),
            );
          },
        ),
      ),
    );
  }

  Widget curretnScreen(AuthState state) {
    switch (state) {
      case AuthState.initialize:
        return const SplashScreen();
      case AuthState.authenticated:
        return const MyNavigationBar();
      case AuthState.unauthenticated:
        return const OnboardScreen();
      default:
        return const SplashScreen();
    }
  }
}
