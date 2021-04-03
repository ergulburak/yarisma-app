import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  final TextStyle _googleFonts = GoogleFonts.robotoMono(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal);
  getAppFont() {
    return _googleFonts;
  }
}
