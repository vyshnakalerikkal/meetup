import 'dart:io';

import 'package:testapp/config/constants.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/utils/country_codes.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:testapp/widgets/custom_mobile_input.dart';
import 'package:testapp/widgets/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../theme/images.dart';
import '../../../utils/helper_functions.dart';

import '../../utils/validators.dart';
import '../../widgets/common_widgets.dart';
import '../../../provider/auth.dart';
import '../../../provider/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  Map<String, String> _selectedCountry = {
    'id': '236',
    'tele_code': '91',
    'country_name': 'Indias',
    'code': 'IN',
    'flag': 'assets/flags/in.png',
  };

  final _formKey = GlobalKey<FormState>();

  void _signup() {
    _mobileController.clear();
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  void _login() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_selectedCountry.isNotEmpty) {
        sendOtp();
      } else {
        AppMessenger.of(context).info('Please select a country');
      }
    }
  }

  void sendOtp() {
   
      ref.read(authProvider).login(
          _selectedCountry['tele_code']! + _mobileController.text.trim());
    
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: Platform.isIOS
          ? AppBar(
              backgroundColor: AppColors.bgGradientTwo,
              elevation: 0,
              leading: appBarBackButton(context, isIOS: true),
            )
          : null,
      body: Container(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height,
        decoration: bgDecoration(),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                color: AppColors.white,
                scale: 2,
                width: context.responsive(165),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  context.responsive(130),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomMobileInputArea(
                        onSaved: (v) {
                          setState(() {
                            _selectedCountry = v;
                          });
                        },
                        filled: false,
                        country: _selectedCountry,
                        countryCodeList: countryCodes,
                        controller: _mobileController,
                        labelText: 'Enter your mobile number',
                        isWhite: true,
                        autofocus: true,
                        validator: MultiValidator([
                          requiredValidator(),
                        ]),
                      ),
                      SizedBox(height: context.responsive(40)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: context.responsive(15),
                            ),
                            child: Text(
                              'Forgot password?',
                              style: textStyle.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: AppColors.white.withOpacity(0.60),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton.secondary(
                text: 'Login',
                onTap: _login,
                isloading: false,
                color: AppColors.primary,
                fontColor: AppColors.white,
                hPadding: 24,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: context.responsive(40),
                    bottom: context.responsive(13),
                  ),
                  child: Text(
                    'Don\'t have an account?',
                    style: textStyle.bodyMedium!.copyWith(
                      fontSize: 15,
                      color: AppColors.white.withOpacity(0.60),
                    ),
                  ),
                ),
              ),
              CustomButton.outlined(
                text: 'Create an account',
                onTap: _signup,
                color: AppColors.white,
                hPadding: 24,
              ),
              const SizedBox(height: 20),
              _listener()
            ],
          ),
        ),
      ),
    );
  }

  Widget _listener() {
    ref.listen<PhoneAuth>(authProvider, (previous, next) {
      if (next.otpState == PhoneState.sendSuccess) {
        Navigator.of(context).pushNamed(AppRoutes.otp,arguments: _selectedCountry['tele_code']! + _mobileController.text.trim());
      }
      if (next.otpState == PhoneState.sendFailed) {
        AppMessenger.of(context).error(next.errorMessage ?? '');
      }
    });
    return const SizedBox.shrink();
  }
}
