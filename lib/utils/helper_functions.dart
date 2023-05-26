import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../theme/colors.dart';

BoxDecoration bgDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.bgGradientTwo,
        AppColors.bgGradientOne,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

Future<File?> compressFile(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf('.');
  final splitted = filePath.substring(0, lastIndex);
  final outPath = '${splitted}_out${filePath.substring(lastIndex)}';
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 50,
  );

  return result;
}
