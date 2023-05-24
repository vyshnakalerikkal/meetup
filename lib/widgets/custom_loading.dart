import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    super.key,
    this.color = AppColors.primary,
    this.strokeWidth = 1,
  });
  final Color color;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: (Platform.isIOS)
          ? CupertinoActivityIndicator(
              color: color,
            )
          : CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            ),
    );
  }
}
