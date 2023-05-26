import 'package:form_field_validator/form_field_validator.dart';

RequiredValidator requiredValidator([String errorText = 'Required field']) {
  return RequiredValidator(errorText: errorText);
}
