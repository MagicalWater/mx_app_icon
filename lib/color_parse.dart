import 'package:image/image.dart';

class ColorParser {
  final int alpha;
  final int red;
  final int green;
  final int blue;

  ColorParser.argb(this.alpha, this.red, this.green, this.blue);

  Color toColor() {
    return ColorUint8.rgba(red, green, blue, alpha);
  }

  factory ColorParser.parse(String colorCode) {
    final originalColorCode = colorCode;
    // 去掉颜色代码的井号
    colorCode = colorCode.replaceAll('#', '');
    // 确定颜色代码的长度
    int length = colorCode.length;

    // 根据颜色代码长度进行解析
    if (length == 3 || length == 6) {
      if (length == 3) {
        // 擴展
        colorCode = expandShortHex(colorCode);
      }
      return parseRRGGBB(colorCode);
    } else if (length == 4 || length == 8) {
      if (length == 4) {
        // 擴展
        colorCode = expandShortHex(colorCode);
      }
      return parseAARRGGBB(colorCode);
    } else {
      throw ArgumentError('無效的顏色代碼: $originalColorCode');
    }
  }

  static ColorParser parseAARRGGBB(String colorCode) {
    int aarrggbb = int.parse(colorCode, radix: 16);
    int alpha = (aarrggbb >> 24) & 0xFF; // 前8位为Alpha通道
    int red = (aarrggbb >> 16) & 0xFF;    // 接下来8位为Red通道
    int green = (aarrggbb >> 8) & 0xFF;   // 再接下来8位为Green通道
    int blue = aarrggbb & 0xFF;           // 最后8位为Blue通道
    return ColorParser.argb(alpha, red, green, blue);
  }

  static ColorParser parseRRGGBB(String colorCode) {
    int rrggbb = int.parse(colorCode, radix: 16);
    int red = (rrggbb >> 16) & 0xFF;    // 前8位为Red通道
    int green = (rrggbb >> 8) & 0xFF;  // 接下来8位为Green通道
    int blue = rrggbb & 0xFF;          // 最后8位为Blue通道
    return ColorParser.argb(255, red, green, blue); // 默认Alpha通道为255（不透明）
  }

  static String expandShortHex(String shortHex) {
    String hex = '';
    for (int i = 0; i < shortHex.length; i++) {
      final c = shortHex[i];
      hex += '$c$c';
    }
    return hex;
  }

  @override
  String toString() {
    return 'ColorParser(alpha: $alpha, red: $red, green: $green, blue: $blue)';
  }
}