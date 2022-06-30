import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class R {
  static final colors = _Colors();
  static final textStyles = _TextStyles();
}

class _Colors {
  final primaryColor = const Color(0xFF00DF80);
  final secondaryColor = const Color(0xFF04131D);
  final backgroundColor = const Color(0xFFF9F9F9);
}

class _TextStyles {
  final loginStype = TextStyle(
    fontSize: ScreenUtil().setSp(20),
    color: const Color(0xFF04131D),
    fontWeight: FontWeight.bold,
  );
}
