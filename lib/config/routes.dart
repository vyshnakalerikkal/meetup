// import 'package:evotaps_flutter/screens/contact/contact_screen.dart';
// import 'package:evotaps_flutter/screens/forgot_password/forgot_password_screen.dart';
// import 'package:evotaps_flutter/screens/privacy_policy/privacy_policy_screen.dart';
// import 'package:evotaps_flutter/screens/reset_password/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/screens/dashboard/bottom_navigation.dart';
import 'package:testapp/screens/home/home_screen.dart';
import 'package:testapp/screens/login/login_screen.dart';
import 'package:testapp/screens/onboard/onboard_screen.dart';
import 'package:testapp/screens/otp/verifiy_otp_screen.dart';
import 'package:testapp/screens/profile/profile_screen.dart';
import 'package:testapp/screens/signup/signup_screen.dart';
import 'package:testapp/screens/splash/splash_screen.dart';

// import '../main.dart';
// import '../screens/login/login_screen.dart';
// import '../screens/manage_card/manage_card_screen.dart';
// import '../screens/onboard/onboard_screen.dart';
// import '../screens/profile/profile_screen.dart';
// import '../screens/setup_profile/setup_profile_screen.dart';
// import '../screens/signup/signup_screen.dart';
// import '../screens/splash/splash_screen.dart';
// import '../screens/verify_otp/verifiy_otp_screen.dart';

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

//   static const forgotPassword = '/forgot_password';
//   static const resetPassword = '/reset_password';
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
      return MaterialPageRoute(builder: (context) =>  HomeScreen());

//     case AppRoutes.setupProfile:
//       return MaterialPageRoute(
//         builder: (context) => const SetupProfileScreen(),
//       );

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
        builder: (context) => VerifiyOtpScreen(
          mobileNumber: settings.arguments as String,
        ),
      );

    case AppRoutes.dashboard:
      return MaterialPageRoute(builder: (context) => const MyNavigationBar());



    default:
      return MaterialPageRoute(
        builder: (context) => const AppInit(),
      );
  }
}
