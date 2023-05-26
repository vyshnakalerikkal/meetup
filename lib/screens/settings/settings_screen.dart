import 'dart:io';
import 'package:testapp/config/constants.dart';
import 'package:testapp/theme/images.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaml/yaml.dart';
import '../../../theme/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _logout() {
    Navigator.pop(context);
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
                  FutureBuilder(
                    future: rootBundle.loadString('pubspec.yaml'),
                    builder: (context, snapshot) {
                      String versionLongString = 'Unknown';
                      String version = 'Unknown';
                      if (snapshot.hasData) {
                        var yaml = loadYaml(
                          snapshot.data.toString(),
                        );
                        versionLongString = yaml['version'];
                        version = versionLongString.split('+')[0];
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: context.responsive(200)),
                        child: Center(
                          child: Text(
                            'Ver $version',
                            style: textStyle.titleSmall!.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.socialMediaLink,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (Platform.isIOS)
                  Padding(
                    padding: EdgeInsets.only(top: context.responsive(200)),
                    child: Center(
                      child: Text(
                        'Ver ${AppConstants.iOSVersion}',
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
