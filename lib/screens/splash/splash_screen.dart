import 'package:testapp/config/routes.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/theme/images.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  final _duration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

   
    _animationController =
        AnimationController(vsync: this, duration: _duration);

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      //ref.read(authProvider).init();
      Navigator.pushReplacementNamed(context,AppRoutes.onboard);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _animation as Animation<double>,
          child: SizedBox(
            width: context.responsive(250),
            child: Image.asset(
              AppImages.logo,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
