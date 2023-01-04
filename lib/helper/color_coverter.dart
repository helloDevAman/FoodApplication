import 'dart:ui';

class ColorConverter{
  static Color stringToColor(String color){
    int value = 0xFFEF7822;
    if(color != null) {
      value = int.parse(color.replaceAll('#', '0xFF'));
    }
    return Color(value);
  }
}