// image_display_mobile.dart

import 'dart:io';
import 'package:flutter/material.dart';

Widget displayImage(String path) {
  return Image.file(File(path));
}
