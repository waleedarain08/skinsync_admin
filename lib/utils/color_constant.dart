import 'package:flutter/material.dart';

class CustomColors {
  // Brand Colors
  static const Color purple = Color(0xFF6750a4);
  static const Color lightPurple = Color(0xFFeaddff);
  static const Color lightPurple2 = Color(0xFFfcf8ff);
  static const Color slateBlue = Color(0xff556caf);
  static const Color slateBlueLight = Color(0xffCED5E8);

  static const Color palePurple = Color(0xFFEEF2FF);
  static const Color purpleHover = Color(0x0D6366F1);

  static const Color green = Color(0xFF10B981);
  static const Color paleGreen = Color(0x2610B981);
  static const Color successBg = Color(0x2610B981);

  static const Color red = Color(0xFFEF4444);
  static const Color paleRed = Color(0x26EF4444);
  static const Color errorBg = Color(0x26EF4444);

  static const Color amber = Color(0xFFF59E0B);
  static const Color paleAmber = Color(0x26F59E0B);
  static const Color warningBg = Color(0x26F59E0B);

  static const Color blue = Color(0xFF3B82F6);
  static const Color paleBlue = Color(0x263B82F6);
  static const Color infoBg = Color(0x263B82F6);

  // Neutrals
  static const Color black = Color(0xFF0F172A);
  static const Color grey = Color(0xFF475569);
  static const Color lightGrey = Color(0xFF94A3B8);
  static const Color softGrey = Color(0xFFF1F5F9);
  static const Color whiteGrey = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Gradients (Descriptive Naming)
  static const LinearGradient purpleWhiteStateBlueLightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      lightPurple2, // Violet 100
      white,
      slateBlueLight// Violet 50
    ],
  );

  static const LinearGradient whiteGreyToSoftGreyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [whiteGrey, softGrey],
  );
}
