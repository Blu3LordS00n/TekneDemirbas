import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class Appstyles {
  // Premium Deniz/Tekne Teması Renk Paleti
  static const Color primaryBlue = Color(0xFF0066CC); // Deniz mavisi
  static const Color secondaryBlue = Color(0xFF00D4FF); // Turkuaz
  static const Color lightBlue = Color(0xFFE6F3FF); // Açık mavi
  static const Color darkBlue = Color(0xFF003366); // Koyu mavi
  static const Color accentBlue = Color(0xFF4A90E2); // Vurgu mavisi
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  
  // Gradientler
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066CC), Color(0xFF00D4FF)],
  );
  
  static const LinearGradient lightOceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE6F3FF), Color(0xFFFFFFFF)],
  );

  // Typography
  static final headingTextStyle = GoogleFonts.poppins(
    fontSize: SizeConfig.getProportionateHeight(24),
    fontWeight: FontWeight.w600,
    color: textDark,
    letterSpacing: 0.5,
  );

  static final titleTextStyle = GoogleFonts.poppins(
    fontSize: SizeConfig.getProportionateHeight(20),
    fontWeight: FontWeight.w500,
    color: textDark,
    letterSpacing: 0.3,
  );

  static final normalTextStyle = GoogleFonts.poppins(
    fontSize: SizeConfig.getProportionateHeight(14),
    fontWeight: FontWeight.w400,
    color: textDark,
    letterSpacing: 0.2,
  );

  static final subtitleTextStyle = GoogleFonts.poppins(
    fontSize: SizeConfig.getProportionateHeight(12),
    fontWeight: FontWeight.w400,
    color: textLight,
    letterSpacing: 0.1,
  );

  // Shadows
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Border Radius
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXLarge = 32.0;
}
