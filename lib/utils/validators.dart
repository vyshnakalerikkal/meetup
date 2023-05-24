import 'package:form_field_validator/form_field_validator.dart';

RequiredValidator requiredValidator([String errorText = 'Required field']) {
  return RequiredValidator(errorText: errorText);
}

LengthRangeValidator lengthValidator(int length, String errorText) {
  return LengthRangeValidator(min: length, max: length, errorText: errorText);
}

final emailValidator = EmailValidator(errorText: 'Please enter a valid email');

class WebsiteValidator extends TextFieldValidator {
  WebsiteValidator({String errorText = 'enter a valid website address'})
      : super(errorText);

  @override
  bool get ignoreEmptyValues => true;
  @override
  bool isValid(String? value) {
    // return true if the value is valid according the your condition
    return hasMatch(
      r'^(https?|ftp)://(-\.)?([^\s/?\.#-]+\.?)+(/[^\s]*)?$',
      value ?? '',
    );
  }
}
