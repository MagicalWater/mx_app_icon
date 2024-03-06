import 'dart:typed_data';
import 'package:image/image.dart';

import 'image_format_detector.dart';

/// 圖片工具
class MxImageUtil {
  /// 檢查是否有alpha通道
  static bool isImageAlphaExist(Uint8List imageBytes) {
    // Load the image
    final image = decodeImage(imageBytes);
    if (image == null) {
      print('Failed to load image.');
      throw Exception('Failed to load image.');
    }

    return image.hasAlpha;
  }

  /// 去除圖片的alpha通道
  static Image removeImageAlpha(Uint8List imageBytes) {
    // Load the image
    final image = decodeImage(imageBytes);
    if (image == null) {
      print('Failed to load image.');
      throw Exception('Failed to load image.');
    }

    return _removeImageAlpha(image);
  }

  /// 重新調整圖片大小
  /// [backgroundColor] - 是否填補背景顏色
  /// [removeAlpha] - 是否移除alpha通道
  static Uint8List resizeImage(
    Uint8List imageBytes,
    int width,
    int height, {
    Color? backgroundColor,
    bool removeAlpha = true,
  }) {
    // Load the image
    var image = decodeImage(imageBytes);
    if (image == null) {
      print('Failed to load image.');
      throw Exception('Failed to load image.');
    }

    if (backgroundColor != null) {
      // 填補背景
      final background = Image(
        width: image.width,
        height: image.height,
        numChannels: image.numChannels,
      );
      fill(background, color: backgroundColor);
      image = compositeImage(background, image);
    }

    if (removeAlpha && image.hasAlpha) {
      image = _removeImageAlpha(image);
    }

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).

    image = copyResize(
      image,
      width: width,
      height: height,
      interpolation: Interpolation.average,
    );

    // 取得圖片格式
    final imageFormat = ImageFormatDetector.detect(imageBytes);

    switch (imageFormat) {
      case ImageFormat.jpg:
        return encodeJpg(image);
      case ImageFormat.png:
        return encodePng(image);
      case ImageFormat.apng:
        return encodePng(image);
      case ImageFormat.gif:
        return encodeGif(image);
      case ImageFormat.bmp:
        return encodeBmp(image);
      case ImageFormat.tiff:
        return encodeTiff(image);
      case ImageFormat.ico:
        return encodeIco(image);
      default:
        // 其餘格式暫時不支持
        throw Exception('Unsupported image format. ($imageFormat)');
    }
  }

  /// 去除圖片的alpha通道
  static Image _removeImageAlpha(Image image) {
    // 沒有透明值的image
    final newImage = Image(
      width: image.width,
      height: image.height,
      numChannels: 3,
    );

    // Set the alpha value to 255 (fully opaque)
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        newImage.setPixel(x, y, pixel);
      }
    }

    return newImage;
  }
}
