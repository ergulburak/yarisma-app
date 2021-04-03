import 'dart:ui';

class HexColor {
  Color getColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
