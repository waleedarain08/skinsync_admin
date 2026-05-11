import 'package:flutter/material.dart';

class CustomColors {
  // Brand Core Palette (Strictly following user request)
  static const Color brandPurple = Color(0xffE7C6E8);
  static const Color brandCyan = Color(0xff88E3FB);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color deepSlate = Color(0xFF1E293B);

  // Surface & Hierarchy
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Derived from Slate palette for separation
  
  // Typography Hierarchy
  static const Color textPrimary = deepSlate;
  static const Color textSecondary = Color(0xFF64748B); // Slate 500 for muted text
  
  // Status Colors (Subtle versions for Premium feel)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = brandCyan;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandCyan, brandPurple],
  );

  // Legacy compatibility (Mapped to new palette where possible to avoid breakages)
  static const Color brandPrimary = deepSlate;
  static const Color lightBlueColor = brandCyan;
  static const Color lightPurpleColor = brandPurple;
  static const Color bottomNavText = textSecondary;
  static const Color blackColor = deepSlate;
  static const Color whiteColor = surfaceWhite;
  static const Color dashboardBackgroundColor = backgroundLight;
  static const Color greyColor = borderLight;
  static const Color iconColor = deepSlate;
  static const Color textGreyColor = textSecondary;
  static const Color blueColor = deepSlate;
  static const Color greenColor = success;
  static const Color drakPurpleColor = brandPurple;
  static const Color textMain = deepSlate;
  static const Color textMuted = textSecondary;
  
  // Additional missing getters identified in analysis
  static const Color surfaceGhost = backgroundLight;
  static const Color deepNavy = deepSlate;
  static const Color successGreen = success;
  static const Color errorRed = error;
  static const Color warningOrange = warning;
  static const Color textDark = textPrimary;
  static const Color textLight = surfaceWhite;
  static const Color softChampagne = backgroundLight;
  static const Color primaryGold = brandCyan;
  static const Color fillColor = surfaceWhite;
  static const Color borderColor = borderLight;
  static const Color textFeildBoaderColor = borderLight;
  static const Color purpleColor = brandPurple;
  static const LinearGradient brandGradient = primaryGradient;
  static const LinearGradient surfaceGradient = primaryGradient;
  static const Color silverColor = borderLight;
}
