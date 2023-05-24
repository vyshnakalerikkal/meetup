import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

Widget appBarBackButton(BuildContext context, {required bool isIOS}) {
  return InkWell(
    onTap: () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Icon(
        isIOS ? CupertinoIcons.back : Icons.arrow_back_rounded,
        color: AppColors.white,
      ),
    ),
  );
}
