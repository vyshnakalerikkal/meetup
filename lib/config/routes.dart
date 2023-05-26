import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/screens/dashboard/bottom_navigation.dart';
import 'package:testapp/screens/home/home_screen.dart';
import 'package:testapp/screens/login/login_screen.dart';
import 'package:testapp/screens/onboard/onboard_screen.dart';
import 'package:testapp/screens/others_profile/others_profile_screen.dart';
import 'package:testapp/screens/otp/verifiy_otp_screen.dart';
import 'package:testapp/screens/profile/profile_screen.dart';
import 'package:testapp/screens/signup/signup_screen.dart';
import 'package:testapp/screens/splash/splash_screen.dart';

class AppRoutes {
  static const init = '/';
  static const splash = '/splash';
  static const onboard = '/onboard';
  static const login = '/login';
  static const otp = '/otp';
  static const signup = '/signup';
  static const profile = '/profile';
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const othersProfile = '/othersProfile';
}

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.init:
      return MaterialPageRoute(
        builder: (context) => const AppInit(),
      );

    case AppRoutes.splash:
      return MaterialPageRoute(builder: (context) => const SplashScreen());

    case AppRoutes.onboard:
      return MaterialPageRoute(builder: (context) => const OnboardScreen());

    case AppRoutes.home:
      return MaterialPageRoute(builder: (context) => const HomeScreen());

    case AppRoutes.profile:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );

    case AppRoutes.login:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case AppRoutes.signup:
      return MaterialPageRoute(builder: (context) => const SignupScreen());

    case AppRoutes.otp:
      return MaterialPageRoute(
        builder: (context) => VerifyOtpScreen(
          mobileNumber: settings.arguments as String,
        ),
      );

    case AppRoutes.dashboard:
      return MaterialPageRoute(builder: (context) => const MyNavigationBar());

    case AppRoutes.othersProfile:
      return MaterialPageRoute(
        builder: (context) => OtherProfileScreen(
          userdetails: settings.arguments as UserModel,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const AppInit(),
      );
  }
}
