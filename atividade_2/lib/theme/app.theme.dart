import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientExtension extends ThemeExtension<GradientExtension> {
  final LinearGradient primaryGradient;

  GradientExtension()
      : primaryGradient = const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  @override
  GradientExtension copyWith({LinearGradient? primaryGradient}) {
    return GradientExtension();
  }

  @override
  GradientExtension lerp(ThemeExtension<GradientExtension>? other, double t) {
    return this;
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(color: Colors.white),
          bodyMedium: GoogleFonts.poppins(color: Colors.white70),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extensions: [GradientExtension()],
        useMaterial3: true,
      );
}
