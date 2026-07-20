import 'package:flutter/material.dart';

/// Color palette for the "My Events" host dashboard
/// + the Add Event / Media Upload creation flow.
class AppColors {
  AppColors._();

  // ---------- Header / brand gradient (bright red top -> deep maroon bottom) ----------
  static const Color headerStart = Color(0xFFE13A46);
  static const Color headerEnd = Color(0xFF6E1029);

  static const Color primaryRed = Color(0xFFE63950);
  static const Color primaryRedDark = Color(0xFFB3182F);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF8A8FA3);
  static const Color scaffoldBg = Color(0xFFFDF7F8);
  static const Color cardBorder = Color(0xFFF1E7E9);

  // ---------- Overview stat cards ----------
  static const Color statPurpleBg = Color(0xFFEBE7FC);
  static const Color statPurpleFg = Color(0xFF7C5CFC);
  static const Color statOrangeBg = Color(0xFFFDECDD);
  static const Color statOrangeFg = Color(0xFFF5A623);
  static const Color statGreenBg = Color(0xFFE1F8EA);
  static const Color statGreenFg = Color(0xFF22C55E);
  static const Color statPinkBg = Color(0xFFFCE4EE);
  static const Color statPinkFg = Color(0xFFEC4899);

  // ---------- Quick action icons ----------
  static const Color actionRedBg = Color(0xFFFCE1E6);
  static const Color actionGreenBg = Color(0xFFDCF7E3);
  static const Color actionOrangeBg = Color(0xFFFFF1DC);

  // ---------- Recent events ----------
  static const Color tagBg = Color(0xFFFCE1EC);
  static const Color tagFg = Color(0xFFEC4899);
  static const Color liveBadgeBg = Color(0xFFE63950);
  static const Color progressBg = Color(0xFFF6D9DD);
  static const Color progressFill = Color(0xFFE63950);
  static const Color onlineDot = Color(0xFF22C55E);

  // ---------- Recent-event action icon chips (view / edit / delete) ----------
  static const Color chipViewBg = Color(0xFFE3ECFB);
  static const Color chipViewFg = Color(0xFF4472D8);
  static const Color chipEditBg = Color(0xFFE1F8EA);
  static const Color chipEditFg = Color(0xFF22C55E);
  static const Color chipDeleteBg = Color(0xFFFCE1E1);
  static const Color chipDeleteFg = Color(0xFFEF4444);

  // ---------- Bottom nav ----------
  static const Color navActive = Color(0xFFE63950);
  static const Color navActiveBg = Color(0xFFFCE1E6);
  static const Color navInactive = Color(0xFFAAA9B4);

  // ---------- Add Event / Media Upload creation flow ----------
  static const Color kRed = Color(0xFFEF5350); // accent red used for progress, border, buttons
  static const Color kPink = Color(0xFFF9C9CB); // pink background wash
  static const Color kPinkLight = Color(0xFFFDEBEC); // lighter pink for panels
  static const Color kBorder = Color(0xFFF3B9BB); // input border pink
  static const Color kTextDark = Color(0xFF1A1A1A);
  static const Color kHint = Color(0xFF9E9E9E);
  static const Color kChipBg = Color(0xFFF6D9D6);
  static const Color kWhite = Colors.white;

  // Full-screen gradient background used on every step of the creation flow
  static const BoxDecoration screenGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2212, 1.0],
      colors: [Color(0xFFFFFFFF), Color(0xFFFBBEBE)],
    ),
  );

  // Header gradient as a reusable decoration too, for consistency
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [headerStart, headerEnd],
  );
}