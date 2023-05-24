import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AppMessenger {
  AppMessenger.of(this.context);

  final BuildContext context;
  success(String message) => Flushbar(
        message: message,
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.green[300],
        ),
        margin: const EdgeInsets.all(6.0),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.bounceInOut,
        textDirection: Directionality.of(context),
        borderRadius: BorderRadius.circular(4),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.green[300],
      )..show(context);

  error(String message) => Flushbar(
        message: message,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.red[300],
        ),
        margin: const EdgeInsets.all(6.0),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.bounceInOut,
        textDirection: Directionality.of(context),
        borderRadius: BorderRadius.circular(12),
        duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.red[300],
      )..show(context);

  info(String message) => Flushbar(
        message: message,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: const EdgeInsets.all(6.0),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.bounceInOut,
        textDirection: Directionality.of(context),
        borderRadius: BorderRadius.circular(12),
        // duration: const Duration(seconds: 2),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
}
