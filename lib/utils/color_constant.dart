import 'package:flutter/material.dart';

class CustomColors {
  // Brand Wellness Palette
  static const Color primary = Color(0xFF6875D5); // Periwinkle Blue
  static const Color secondary = Color(0xFF6BCFA4); // Mint Green
  static const Color accent = Color(0xFF6875D5);

  // Backgrounds & Surfaces
  static const Color backgroundStart = Color(0xFFE0ECFB); // Soft Sky Blue
  static const Color backgroundEnd = Color(0xFFD7D6F4); // Muted Periwinkle
  static const Color sidebar = Color(0xFFDDE5F5); // Bluish-Lavender Sidebar
  static const Color card = Color(0xFFFFFFFF); // Pure White

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2843); // Deep Slate Navy
  static const Color textSecondary = Color(0xFF7C86A2); // Gray-Blue Muted
  static const Color textTertiary = Color(0xFF94A3B8);

  // Interaction States
  static const Color activeItemState = Color(0xFFC9D6F5); // Sidebar Active Fill

  // Surface Aliases for internal logic
  static const Color surfaceWhite = card; 
  static const Color backgroundLight = Color(0xFFE0ECFB);
  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color borderFocus = primary;
  static const Color primarySoft = activeItemState;
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color surfaceGhost = Color(0xFFF8FAFC);
  
  // Status Colors
  static const Color success = secondary;
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = primary;

  // Status Backgrounds (Constant hex with alpha)
  static const Color successBg = Color(0x266BCFA4);
  static const Color errorBg = Color(0x26EF4444);
  static const Color warningBg = Color(0x26F59E0B);
  static const Color infoBg = Color(0x266875D5);

  // Gradients
  static const LinearGradient mainCanvasGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundStart, backgroundEnd],
  );

  static const LinearGradient medicalGradient = mainCanvasGradient;
  static const LinearGradient brandGradientDiagonal = mainCanvasGradient;
  static const LinearGradient primaryGradient = mainCanvasGradient;

  // Legacy Aliases - DO NOT REMOVE (Prevents code breaks)
  static const Color deepSlate = textPrimary;
  static const Color brandCyan = secondary;
  static const Color brandPurple = primary;
  static const Color brandPrimary = primary;
  static const Color selected = activeItemState;
  static const Color hover = Color(0x0D6875D5);
  static const Color textOnDark = Colors.white;
  static const Color textMuted = textSecondary;
  static const Color primaryGold = Color(0xFFF59E0B);
  static const Color warningOrange = Color(0xFFEF4444);
  static const Color successGreen = secondary;
  static const Color errorRed = Color(0xFFEF4444);
  static const Color lightBlueColor = primary;
  static const Color lightPurpleColor = primary;
  static const Color deepNavy = textPrimary;
  static const Color purpleColor = primary;
  static const Color textMain = textPrimary;
  static const Color primaryLight = Color(0xFF98A2E8);
  static const Color softChampagne = sidebar;
  static const Color greyColor = textTertiary;
  static const Color textLight = Colors.white;
  static const Color textDark = textPrimary;
  static const Color fillColor = Colors.white;
  static const Color borderColor = borderLight;
  static const Color whiteColor = Colors.white;
  static const Color dashboardBackgroundColor = backgroundStart;
  static const Color textFeildBoaderColor = borderLight;
  static const Color blueColor = primary;
  static const Color greenColor = secondary;
  static const Color sidebarBorder = borderLight;
}
