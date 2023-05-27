import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/theme/images.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _logout() {
    ref.read(authProvider).logOut();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.init, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.primary,
            child: Image.asset(
              AppImages.logo,
              scale: 2,
              color: AppColors.white,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: context.responsive(20)),
                _drawerOptions(
                  textStyle,
                  text: 'Contact',
                  icon: AppImages.contact,
                  onTap: () {},
                ),
                _drawerOptions(
                  textStyle,
                  text: 'Privacy policy',
                  icon: AppImages.privacyPolicy,
                  onTap: () {},
                ),
                _drawerOptions(
                  textStyle,
                  text: 'Logout',
                  icon: AppImages.logout,
                  onTap: _logout,
                ),
                if (Platform.isAndroid)
                  Padding(
                    padding: EdgeInsets.only(top: context.responsive(100)),
                    child: Center(
                      child: Text(
                        'Ver 1.0.0',
                        style: textStyle.titleSmall!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.socialMediaLink,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerOptions(
    TextTheme textStyle, {
    required String text,
    required String icon,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset(icon),
        title: Text(
          text,
          style: textStyle.bodyMedium!.copyWith(
            color: AppColors.formSectionTitle,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
