import 'dart:io';
import 'package:testapp/config/routes.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/provider/signup.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/utils/country_codes.dart';
import 'package:testapp/utils/validators.dart';
import 'package:testapp/widgets/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testapp/widgets/custom_snackbar.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../widgets/custom_mobile_input.dart';
import 'package:intl/intl.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _gender = '';

  final FocusNode dobFocus = FocusNode();

  final bool _isIOS = Platform.isIOS;

  final List<DropDownValue> _genderList = [
    DropDownValue(title: 'Male', value: 'male'),
    DropDownValue(title: 'Female', value: 'female'),
    DropDownValue(title: 'Others', value: 'others'),
  ];

  Map<String, String> _selectedCountry = {
    'id': '236',
    'tele_code': '91',
    'country_name': 'Indias',
    'code': 'IN',
    'flag': 'assets/flags/in.png',
  };

  void _signup() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> data = {
        'name': _nameController.text,
        'dob': _dobController.text,
        'gender': _gender,
        'location': _locationController.text,
        'mobile': _selectedCountry['tele_code']! + _mobileController.text,
        'about': '',
        'image': '',
      };
      ref.read(signupProvider).signup(data);
    }
  }

  Widget _listener() {
    ref.listen<SignupProvider>(signupProvider, (previous, next) {
      if (next.status == Status.success) {
        AppMessenger.of(context).success('Signup successful');
        Future.delayed(const Duration(milliseconds: 2000)).then((value) =>
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false));
      } else if ((next.status == Status.error)) {
        AppMessenger.of(context).error(next.message);
      }
    });
    return const SizedBox.shrink();
  }

  _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2012),
      firstDate: DateTime(1975),
      lastDate: DateTime(2012),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

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
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: !_isIOS ? context.responsive(75) : 0,
                  left: 24,
                ),
                child: Text(
                  'Let\'s get\nstarted',
                  style: textStyle.headlineMedium!.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  context.responsive(45),
                  24,
                  context.responsive(70),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextfield(
                        labelText: 'Name',
                        isWhite: true,
                        autoFocus: true,
                        controller: _nameController,
                        validator: requiredValidator(),
                      ),
                      _formFieldGap(),
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
                        labelText: 'Mobile number',
                        isWhite: true,
                        autofocus: true,
                        validator: MultiValidator([
                          requiredValidator(),
                        ]),
                      ),
                      _formFieldGap(),
                      CustomDropdownField(
                        onChanged: (gender) {
                          setState(() {
                            _gender = gender!.value;
                          });
                        },
                        items: _genderList,
                        labelText: 'Gender',
                        isWhite: true,
                      ),
                      _formFieldGap(),
                      CustomTextfield(
                          labelText: 'Date of birth',
                          isWhite: true,
                          autoFocus: false,
                          controller: _dobController,
                          validator: requiredValidator(),
                          enabled: true,
                          suffix: const Icon(
                            Icons.calendar_today,
                            color: AppColors.white,
                            size: 20,
                          ),
                          onSuffixTap: () {
                            _selectDate();
                          }),
                      _formFieldGap(),
                      CustomTextfield(
                        labelText: 'Location',
                        isWhite: true,
                        keyboardType: TextInputType.text,
                        controller: _locationController,
                        validator: MultiValidator([
                          requiredValidator(),
                        ]),
                      ),
                      _formFieldGap(),
                    ],
                  ),
                ),
              ),
              Consumer(builder: (_, ref, __) {
                final res = ref.watch(signupProvider);

                return CustomButton.secondary(
                  text: 'Create account',
                  onTap: _signup,
                  isloading: res.status == Status.loading,
                  color: AppColors.primary,
                  fontColor: AppColors.white,
                  hPadding: 24,
                );
              }),
              SizedBox(height: context.responsive(123)),
              _listener()
            ],
          ),
        ),
      ),
    );
  }

  Widget _formFieldGap() {
    return SizedBox(
      height: context.responsive(40),
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
}
