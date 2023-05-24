import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneAuth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String _phoneNumber = '';
  String? _errorMessage = '';
  String _verificationId = '';

  PhoneState phoneStatus = PhoneState.initilize;
  OtpState otpState = OtpState.initilize;

  String? get errorMessage => _errorMessage;
  String get phonNumber => _phoneNumber;

  Future<void> login(String phoneNumber) async {
    _phoneNumber = phoneNumber;
    _errorMessage = '';
    phoneStatus = PhoneState.loading;
    sendOTP();
    notifyListeners();
  }

  Future<void> sendOTP() async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential _user = await auth.signInWithCredential(credential);
         _changeOtpState(OtpState.success);
        },
        verificationFailed: (FirebaseAuthException e) {
          _errorMessage = e.message;
          _changeOtpState(OtpState.error);
        },
        codeSent: (String verficationID, int? resendToken) {
          _verificationId = verficationID;
          _changePhoneState(PhoneState.sendSuccess);
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationId = verificationID;
          _errorMessage = 'Time out';
          _changeOtpState(OtpState.timeout);
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _changePhoneState(PhoneState.sendFailed);
    }
  }

  loginWithOtp(String otp) async {
    _changeOtpState(OtpState.loading);

    try {
      UserCredential _user = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        ),
      );
      _changeOtpState(OtpState.success);
    
    } catch (e) {
      _errorMessage = e.toString();
      if (_errorMessage?.contains('invalid-verification-code') ?? false) {
        _errorMessage = 'Invalid opt';
      }
      _changeOtpState(OtpState.error);
    }
  }

  // Future<void> getUserData(UserCredential user) async {
  //   // if the user logins for first time
  //   // save the user phone and uui to firestore
  //   if (user.additionalUserInfo!.isNewUser) {
  //     await FirbaseApi().createUser();
  //   }
  //   _changeOtpState(OtpState.success);
  // }

  Future<void> logOut() async {
    await auth.signOut();
  }

  _changePhoneState(PhoneState value) {
    phoneStatus = value;
    notifyListeners();
  }

  _changeOtpState(OtpState value) {
    otpState = value;
    notifyListeners();
  }
}

enum PhoneState { initilize, sendSuccess, sendFailed, loading }
enum OtpState { initilize, loading, timeout, error, success }
