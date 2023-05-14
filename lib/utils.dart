import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  // Setting the color

  static Color bgColor = const Color(0xFFFFFFFF);
  static Color mainColor = const Color(0xFF9ED321);
  static Color accentColor = const Color(0xFFAE373D);
  static Color primaryColor = const Color(0xFF000000);
  static Color secondaryColor = const Color(0xFF838383);
  static Color thirdColor = const Color(0xFFD9D9D9);

  // Setting the text style
  static TextStyle mainTitle =
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle mainContent =
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle mainDescription =
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal);
}
