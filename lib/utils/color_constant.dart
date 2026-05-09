import 'package:flutter/material.dart';

class CustomColors {
  // Brand Identity (Derived from splash_logo.png colors)
  static const Color brandPrimary = Color(0xFF1763E0); // Vibrant Blue
  static const Color brandCyan = Color(0xff88E3FB);    // Soft Cyan (Logo)
  static const Color brandPurple = Color(0xffE7C6E8);  // Soft Lavender (Logo)
  
  // Luxury UI Surface Palette
  static const Color deepSlate = Color(0xFF1E293B);    // Modern Deep Blue-Grey
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGhost = Color(0xFFF1F5F9);
  
  // Typography
  static const Color textMain = Color(0xFF0F172A);     // Slate 900
  static const Color textMuted = Color(0xFF64748B);    // Slate 500
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff88E3FB), Color(0xffE7C6E8)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
  );

  // Legacy compatibility (Restored to prevent compilation errors)
  static const Color lightBlueColor = Color(0xff88E3FB);
  static const Color lightPurpleColor = Color(0xffE7C6E8);
  static const Color bottomNavText = Color(0xff636363);
  static const Color purpleColor = Color(0xffEEA1F0);
  static const Color blackColor = Color(0xff000000);
  static const Color borderColor = Color(0x1010101A);
  static const Color whiteColor = Color(0xffffffff);
  static const Color dashboardBackgroundColor = Color(0xffF9FAFB);
  static const Color silverColor = Color(0xff657296);
  static const Color greyColor = Color(0xffE9E9E9);
  static const Color iconColor = Color(0xffF2F2F2);
  static const Color textGreyColor = Color(0xff494949);
  static const Color textFeildBoaderColor = Color(0xff939393);
  static const Color blueColor = Color(0xFF1763E0);
  static const Color fillColor = Color(0xffF3F3F5);
  static const Color greenColor = Color(0Xff00A63E);
  static const Color drakPurpleColor = Color(0xFF4F39F6);

  // Luxury MedSpa Palette (Previous version items)
  static const Color primaryGold = Color(0xFFC5A358);
  static const Color deepNavy = Color(0xFF1A1F2C);
  static const Color softChampagne = Color(0xFFF7F3F0);
  static const Color luxuryWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textLight = Color(0xFF636E72);
  static const Color accentRose = Color(0xFFE8B3B3);
  static const Color successGreen = Color(0xFF55B938);
  static const Color errorRed = Color(0xFFD63031);
  static const Color warningOrange = Color(0xFFF39C12);
}
