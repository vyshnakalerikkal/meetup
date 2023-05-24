import 'package:testapp/utils/build_context.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomDropdownField extends StatefulWidget {
  const CustomDropdownField({
    Key? key,
    this.titleText = '',
    this.items = const [],
    required this.onChanged,
    this.validator,
    this.value,
    this.hint,
    this.border = false,
    this.hPadding = 0,
    // this.color = _black,
    this.vPadding = 0,
    this.initialValue,
    this.labelText,
    this.isWhite = false,
  }) : super(key: key);

  final String titleText;
  final List<DropDownValue> items;
  final Function(DropDownValue?)? onChanged;
  final String? Function(DropDownValue?)? validator;
  final DropDownValue? value;
  final String? hint;
  final bool border;
  final double vPadding;
  final double hPadding;
  final String? initialValue;
  final String? labelText;
  final bool isWhite;
  // final Color color;

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  DropDownValue? _selectedValue;

  @override
  void initState() {
    setInitialValue();
    super.initState();
  }

  setInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _selectedValue = widget.items
          .firstWhere((element) => element.value == widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: widget.isWhite
            ? AppColors.formFieldUnderlineTwo
            : AppColors.formFieldUnderline,
      ),
    );
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: widget.isWhite ? AppColors.white : AppColors.formFieldText,
          fontWeight: FontWeight.w500,
        );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.hPadding,
        widget.vPadding,
        widget.hPadding,
        0,
      ),
      child: DropdownButtonFormField<DropDownValue>(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: widget.isWhite ? AppColors.white : AppColors.primary,
        ),
        iconSize: context.responsive(25),
        hint: widget.hint != null
            ? Text(
                widget.hint!,
                style: textStyle.copyWith(color: AppColors.formFieldLabelTwo),
              )
            : null,
        isExpanded: true,
        elevation: 0,
        menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
        validator: widget.validator,
        items: widget.items.map((DropDownValue value) {
          return DropdownMenuItem<DropDownValue>(
            value: value,
            child: Text(
              value.title,
              style: textStyle.copyWith(color: AppColors.white),
            ),
          );
        }).toList(),
        value: _selectedValue,
        onChanged: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (widget.onChanged != null && value != null) {
            widget.onChanged!(value);
          }
        },
        style: textStyle,
        dropdownColor: AppColors.formFieldText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: textStyle.copyWith(color: AppColors.formFieldLabelTwo),
          border: textFieldBorder,
          enabledBorder: textFieldBorder,
          errorBorder: textFieldBorder,
          focusedBorder: textFieldBorder,
          errorStyle: textStyle.copyWith(color: AppColors.red),
          // contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}

class DropDownValue {
  DropDownValue({
    required this.title,
    required this.value,
    this.etc,
  });
  final String title;
  final String value;
  final String? etc;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropDownValue &&
        other.value == value &&
        other.title == title;
  }

  @override
  int get hashCode => value.hashCode ^ title.hashCode;
}
