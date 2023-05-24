import 'dart:async';

import 'package:testapp/utils/build_context.dart';
import 'package:flutter/material.dart';

void customDialog(
  BuildContext context, {
  required Widget child,
  bool barrierDismissible = true,
  double horizontalPadding = 22.0,
  FutureOr<dynamic> Function()? onTimeout,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return CustomDialog(
        barrierDismissible: barrierDismissible,
        horizontalPadding: horizontalPadding,
        child: child,
      );
    },
  ).timeout(
    Duration(seconds: (onTimeout != null) ? 2 : 0),
    onTimeout: onTimeout,
  );
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.child,
    required this.barrierDismissible,
    required this.horizontalPadding,
  }) : super(key: key);
  final Widget child;
  final bool barrierDismissible;
  final double horizontalPadding;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.barrierDismissible,
      child: Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
          padding: EdgeInsets.all(context.responsive(22)),
          child: widget.child,
        ),
      ),
    );
  }
}
