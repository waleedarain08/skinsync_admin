import 'package:flutter/material.dart';

class CustomColors {
  // Brand Wellness Palette
  static const Color primary = Color(0xFF7d4897); // Modern Indigo
  static const Color secondary = Color(0xFF10B981); // Emerald Green

  // Backgrounds & Surfaces
  static const Color backgroundStart = Color(0xFFF8FAFC); // Slate 50
  static const Color backgroundEnd = Color(0xFFF1F5F9); // Slate 100
  static const Color sidebar = Color(0xFFFFFFFF); // Clean White Sidebar
  static const Color card = Color(0xFFFFFFFF); // Pure White

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 (High Contrast)
  static const Color textSecondary = Color(0xFF475569); // Slate 600 (Readable Inactive)
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400 (Muted but visible)

  // Interaction States
  static const Color activeItemState = Color(0xFFEEF2FF); // Indigo 50
  static const Color hoverState = Color(0xFFF1F5F9); // Slate 100

  // Surface Aliases for internal logic
  static const Color surfaceWhite = card; 
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color borderFocus = primary;
  static const Color primarySoft = Color(0xFFEEF2FF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color surfaceGhost = Color(0xFFF8FAFC);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Status Backgrounds (Constant hex with alpha)
  static const Color successBg = Color(0x2610B981);
  static const Color errorBg = Color(0x26EF4444);
  static const Color warningBg = Color(0x26F59E0B);
  static const Color infoBg = Color(0x263B82F6);

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
  static const Color hover = Color(0x0D6366F1);
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
  static const Color primaryLight = Color(0xFFA5B4FC);
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
