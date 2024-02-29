import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:image/image.dart';

import 'bean/ios_icon_struct/ios_icon_struct.dart';

import 'util.dart';

/// app的圖標產生
class MxAppIconGenerator {
  /// 產生ios app icon的圖標
  /// [imageBytes] - 原本的圖標bytes
  /// [targetDir] - 目標資料夾: 通常指向到 ios/Runner/Assets.xcassets/AppIcon.appiconset
  /// 產生的size列表
  /// 20x20(x2,x3)
  /// 29x29(x2,x3)
  /// 38x38(x2,x3)
  /// 40x40(x2,x3)
  /// 60x60(x2,x3)
  /// 64x64(x2,x3)
  /// 68x68(x2)
  /// 76x76(x2)
  /// 83.5x83.5(x2)
  /// 1024x1024
  void generateIosIcon(
    Uint8List imageBytes,
    Directory targetDir,
    Color? backgroundColor,
  ) {
    final sizeList = [
      IosIconSize(size: 20, multiple: [2, 3]),
      IosIconSize(size: 29, multiple: [2, 3]),
      IosIconSize(size: 38, multiple: [2, 3]),
      IosIconSize(size: 40, multiple: [2, 3]),
      IosIconSize(size: 60, multiple: [2, 3]),
      IosIconSize(size: 64, multiple: [2]),
      IosIconSize(size: 76, multiple: [2]),
      IosIconSize(size: 83.5, multiple: [2]),
      IosIconSize(size: 1024),
    ];

    targetDir.createSync(recursive: true);

    final imageBeans = <IosIconStructImagesBean>[];

    for (var size in sizeList) {
      for (var multiple in size.multiple) {
        // 雖然只能整數, 但目前唯一有小數點的83.5是x2, 所以不會有誤差
        final imageSize = (size.size * multiple).toInt();
        final newImageBytes = MxImageUtil.resizeImage(
          imageBytes,
          imageSize,
          imageSize,
          removeAlpha: true,
          backgroundColor: backgroundColor,
        );
        final imageName = size.iconName(multiple);

        final bean = IosIconStructImagesBean(
          size: '${size.size}x${size.size}',
          idiom: 'universal',
          filename: '$imageName.png',
          scale: '${multiple}x',
          platform: 'ios',
        );

        imageBeans.add(bean);

        // 把圖片寫入檔案
        File('${targetDir.path}/${bean.filename}')
            .writeAsBytesSync(newImageBytes);
      }
    }

    // 最後生成對應圖檔的結構json
    final structBean = IosIconStructBean(
      images: imageBeans,
      info: IosIconStructInfoBean(
        version: 1,
        author: 'com.mx.appicon',
      ),
    );

    final encoder = JsonEncoder.withIndent('    ');
    final structString = encoder.convert(structBean.toJson());

    File('${targetDir.path}/Contents.json').writeAsStringSync(structString);
  }

  /// 產生android app icon的圖標
  /// [imageBytes] - 原本的圖標bytes
  /// [targetDir] - 目標資料夾: 通常指向到 android/app/src/main/res/
  /// 檔案名稱固定為ic_launcher.png
  /// 產生的size列表
  /// mipmap-mdpi => 48x48
  /// mipmap-hdpi => 72x72
  /// mipmap-xhdpi => 96x96
  /// mipmap-xxhdpi => 144x144
  /// mipmap-xxxhdpi => 192x192
  void generateAndroidIcon(
    Uint8List imageBytes,
    Directory targetDir,
    Color? backgroundColor,
  ) {
    final sizeList = [
      AndroidIconSize(size: 48, name: 'mipmap-mdpi'),
      AndroidIconSize(size: 72, name: 'mipmap-hdpi'),
      AndroidIconSize(size: 96, name: 'mipmap-xhdpi'),
      AndroidIconSize(size: 144, name: 'mipmap-xxhdpi'),
      AndroidIconSize(size: 192, name: 'mipmap-xxxhdpi'),
    ];

    for (var size in sizeList) {
      final newImageBytes = MxImageUtil.resizeImage(
        imageBytes,
        size.size,
        size.size,
        removeAlpha: false,
        backgroundColor: backgroundColor,
      );

      // 先創建資料夾, 若有需要
      Directory('${targetDir.path}/${size.name}').createSync(recursive: true);

      // 把圖片寫入檔案
      File('${targetDir.path}/${size.name}/ic_launcher.png')
          .writeAsBytesSync(newImageBytes);
    }
  }
}

class IosIconSize {
  final double size;
  final List<int> multiple;
  final String namePrev;

  String iconName(int multiple) {
    final sizeDecimal = Decimal.parse(size.toString());
    final sizeText = sizeDecimal.toString();
    if (multiple > 1) {
      return '$namePrev$sizeText@${multiple}x';
    }
    return '$namePrev$sizeText';
  }

  const IosIconSize({
    required this.size,
    this.multiple = const [1],
    this.namePrev = 'icon-',
  });
}

class AndroidIconSize {
  final int size;
  final String name;

  const AndroidIconSize({
    required this.size,
    required this.name,
  });
}
