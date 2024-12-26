import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // font manrope from google fonts : GoogleFonts.manrope().fontFamily
  static String? manropeFontFamily = GoogleFonts.manrope().fontFamily;

  //Headings
  static TextStyle titleLarge = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.4,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w900,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.32,
  );

  static TextStyle titleSmall = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.28,
  );

  //Body
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.02,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.24,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: manropeFontFamily,
    letterSpacing: 0.24,
  );
}
