import 'dart:io';

import 'package:testapp/config/routes.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../theme/colors.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../provider/auth.dart';
import '../../../provider/provider.dart';

class VerifiyOtpScreen extends ConsumerStatefulWidget {
  const VerifiyOtpScreen({Key? key, required this.mobileNumber})
      : super(key: key);
  final String mobileNumber;

  @override
  ConsumerState<VerifiyOtpScreen> createState() => _VerifiyOtpScreenState();
}

class _VerifiyOtpScreenState extends ConsumerState<VerifiyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: _isIOS
          ? AppBar(
              backgroundColor: AppColors.bgGradientTwo,
              elevation: 0,
              leading: _iOSBackButton(),
            )
          : null,
      body: Container(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height,
        decoration: bgDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _title(textStyle),
              _subTitle(textStyle),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  context.responsive(125),
                  24,
                  context.responsive(110),
                ),
                child: Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    controller: _otpController,
                    length: 4,
                    animationType: AnimationType.fade,
                    textStyle: textStyle.titleLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                    pinTheme: PinTheme(
                      activeFillColor: Colors.white,
                      activeColor: const Color(0xFFEAEAEA),
                      inactiveColor: const Color(0xFFEAEAEA),
                      selectedColor: const Color(0xFFFFA800),
                      fieldWidth: (MediaQuery.of(context).size.width / 4) - 20,
                    ),
                    enablePinAutofill: true,
                    showCursor: false,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      _verifyOtp();
                    },
                    onChanged: (value) {},
                  ),
                ),
              ),
              CustomButton.secondary(
                text: 'Verify OTP',
                onTap: _verifyOtp,
                isloading: true,
                color: AppColors.primary,
                fontColor: AppColors.white,
                hPadding: 24,
              ),
              _listener(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iOSBackButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          CupertinoIcons.back,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _title(TextTheme textStyle) => Padding(
        padding: EdgeInsets.only(
          top: _isIOS ? context.responsive(25) : context.responsive(75),
          left: 24,
        ),
        child: Text(
          'Verify your\nPhone number',
          style: textStyle.headlineMedium!.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      );

  Widget _subTitle(TextTheme textStyle) => Padding(
        padding: EdgeInsets.only(
          top: context.responsive(15),
          left: 24,
        ),
        child: RichText(
          text: TextSpan(
            text:
                'Enter 4 Digit verification code that we\nsent to your mobile number ',
            style: textStyle.bodyMedium!.copyWith(
              fontSize: 15,
              color: AppColors.white.withOpacity(0.6),
            ),
            children: [
              TextSpan(
                text: widget.mobileNumber,
                style: textStyle.bodyMedium!.copyWith(
                  fontSize: 15,
                  color: AppColors.otpScreenMobile,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _listener() {
    ref.listen<PhoneAuth>(authProvider, (previous, next) {
      if (next.otpState == OtpState.success) {
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.init));
      }
      if (next.otpState == OtpState.error) {
        AppMessenger.of(context).error(next.errorMessage ?? '');
      }
    });
    return const SizedBox.shrink();
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      if (_otpController.text.length < 4) {
        AppMessenger.of(context)
            .info('Please enter a valid OTP Code to continue!');
      } else {
        _submitOtp();
      }
    } else {
      AppMessenger.of(context).info('Please enter OTP Code to continue!');
    }
  }

  void _submitOtp() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(authProvider).loginWithOtp(_otpController.text.trim());
    }
  }
}
