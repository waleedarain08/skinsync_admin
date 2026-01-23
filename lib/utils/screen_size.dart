import 'dart:developer';

import 'package:flutter/material.dart';

Size getDesignSize({required BuildContext context}) {
  const sizesMap = {
    'LARGE': Size(1200, 1600),
    'MEDIUM': Size(768, 1024),
    'SMALL': Size(600, 900),
    'DEFAULT': Size(375, 812),
  };
  final window = View.of(context);
  final size = window.physicalSize / window.devicePixelRatio;
  late String name;
  if (size.width >= 1200) {
    name = 'LARGE';
  } else if (size.width >= 800) {
    name = 'MEDIUM';
  } else if (size.width >= 600) {
    name = 'SMALL';
  } else {
    name = 'DEFAULT';
  }
  log('NAME: $name');
  final appSize = sizesMap[name]!;
  return size.width > size.height
      ? Size(appSize.height, appSize.width)
      : appSize;
}
