import 'package:testapp/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'custom_loading.dart';
import 'custom_textfield.dart';

class CustomMobileInputArea extends StatefulWidget {
  const CustomMobileInputArea({
    Key? key,
    required this.onSaved,
    this.hintText = '',
    required this.country,
    this.hPadding = 0,
    this.titleText = '',
    this.vPadding = 0,
    this.filled = true,
    required this.controller,
    this.validator,
    this.isLoading = false,
    this.countryCodeList = const [],
    this.isWhite = false,
    this.labelText,
    this.autofocus = false,
  }) : super(key: key);

  final Function(Map<String, String>) onSaved;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double vPadding;
  final String titleText;
  final double hPadding;
  final bool filled;
  final List<Map<String, String>> countryCodeList;
  final bool isLoading;
  final Map<String, String> country;
  final bool isWhite;
  final String? labelText;
  final bool autofocus;

  @override
  State<CustomMobileInputArea> createState() => _MobilePickerState();
}

class _MobilePickerState extends State<CustomMobileInputArea> {
  final textFieldBorder = const UnderlineInputBorder(
    // borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.formFieldUnderline),
  );
  final circularBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  Map<String, String> _countryCode = {};
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.trim().isEmpty) {
      validationMessage = 'Can\'t be empty';
    }
    setInitialValue();
  }

  void setInitialValue() {
    _countryCode['tele_code'] = widget.country['tele_code'] ?? '';
    _countryCode['flag'] = widget.country['flag'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: widget.isWhite ? AppColors.white : AppColors.formFieldText,
          fontWeight: FontWeight.w500,
        );
    // final borderColor = widget.isWhite
    //     ? AppColors.formFieldUnderlineTwo
    //     : AppColors.formFieldUnderline;
    final cursorColor =
        widget.isWhite ? AppColors.formFieldUnderlineTwo : AppColors.primary;
    if (widget.filled) setInitialValue();
    return Padding(
      padding: EdgeInsets.only(
        top: widget.vPadding,
        right: widget.hPadding,
        left: widget.hPadding,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              autofocus: widget.autofocus,
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              onChanged: (_) => widget.validator,
              onSaved: (value) => widget.validator,
              style: textStyle,
              validator: widget.validator,
              cursorColor: cursorColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: textFieldBorder,
                enabledBorder: textFieldBorder,
                errorBorder: textFieldBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: textFieldBorder,
                filled: widget.filled,
                hintText: widget.hintText,
                hintStyle: textStyle,
                labelText: widget.labelText,
                labelStyle:
                    textStyle.copyWith(color: AppColors.formFieldLabelTwo),
                prefix: widget.isLoading
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        width: context.responsive(78),
                        height: context.responsive(25),
                        child: const FittedBox(child: CustomLoadingWidget()),
                      )
                    : SizedBox(
                        width: 85,
                        child: codeList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future countrycodeDialog() async {
    final data = await showModalBottomSheet<dynamic>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return CountrycodePicker(
          countryCodeList: widget.countryCodeList,
        );
      },
    );
    if (data != null) {
      _countryCode = data;
      widget.onSaved(data);
      validate();
      setState(() {});
    }
  }

  Future<void> validate() async {
    validationMessage = await validateMobileNumber(
      widget.controller.text,
      _countryCode['tele_code']!,
    );
  }

  Future<String?> validateMobileNumber(
    String mobile,
    String countryCode,
  ) async {
    return null;
  }

  GestureDetector codeList() {
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: widget.isWhite ? AppColors.white : AppColors.formFieldText,
          fontWeight: FontWeight.w500,
        );

    return GestureDetector(
      onTap: countrycodeDialog,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.only(left: context.responsive(15)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset(
            //   _countryCode['flag'] ?? '',
            //   width: 23,
            //   height: 23,
            // ),
            // SizedBox(width: context.responsive(3)),
            Text(
              _countryCode['tele_code'] != null
                  ? _countryCode['tele_code']!.contains('+')
                      ? (_countryCode['tele_code'] ?? ')')
                      : ('+${_countryCode['tele_code'] ?? ')'}')
                  : '',
              style: textStyle,
            ),
            // SizedBox(width: context.responsive(10)),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.formFieldUnderlineTwo,
            ),
          ],
        ),
      ),
    );
  }
}

class CountrycodePicker extends StatefulWidget {
  const CountrycodePicker({
    Key? key,
    this.countryCodeList = const [],
  }) : super(key: key);
  final List<Map<String, String>> countryCodeList;

  @override
  State<CountrycodePicker> createState() => _CountrycodePickerState();
}

class _CountrycodePickerState extends State<CountrycodePicker> {
  final ValueNotifier<List<Map>> filtered = ValueNotifier<List<Map>>([]);

  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocus = FocusNode();

  bool searching = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return ValueListenableBuilder<List>(
      valueListenable: filtered,
      builder: (context, value, _) {
        return Container(
          // margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 5,
                  width: 100,
                ),
              ),
              CustomTextfield(
                hPadding: context.responsive(24),
                hintText: 'Search',
                suffix: Padding(
                  padding: EdgeInsets.all(context.responsive(15)),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                  ),
                ),
                onSuffixTap: () {
                  searchController.clear();
                  searching = false;
                  filtered.value = [];
                  if (searchFocus.hasFocus) searchFocus.unfocus();
                },
                prefix: Padding(
                  padding: EdgeInsets.all(context.responsive(15)),
                  child: const Icon(
                    CupertinoIcons.search,
                    color: AppColors.primary,
                  ),
                ),
                controller: searchController,
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    searching = true;
                    filtered.value = [];
                    for (var user in widget.countryCodeList) {
                      if (user['country_name']
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          user['tele_code'].toString().contains(text)) {
                        filtered.value.add(user);
                      }
                    }
                  } else {
                    searching = false;
                    filtered.value = [];
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: searching
                      ? filtered.value.length
                      : widget.countryCodeList.length,
                  itemBuilder: (context, index) {
                    final item = searching
                        ? filtered.value[index]
                        : widget.countryCodeList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                        title: Text(
                          '${item['country_name']} ',
                          style: textStyle.bodyMedium!.copyWith(
                            color: AppColors.bgGradientOne,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          '+ ${item['tele_code']}',
                          style: textStyle.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
