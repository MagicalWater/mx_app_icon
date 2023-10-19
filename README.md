Language: [English](README.md) | [中文](README_ZH.md)

# mx_app_icon
[![Pub](https://img.shields.io/pub/v/mx_app_icon.svg?style=flat-square)](https://pub.dartlang.org/packages/mx_app_icon)

App icon generator.


## Usage

#### 1. Use this package as a library
add mx_app_icon to dependencies

```yaml
dev_dependencies:
   mx_app_icon: any
```

```dart
import 'package:mx_app_icon/mx_app_icon.dart';

void main(List<String> args) {
   final generator = MxAppIconGenerator();

   final iconFile = File('圖片路徑');

   final iosDir = Directory('./ios/Runner/Assets.xcassets/AppIcon.appiconset');
   final androidDir = Directory('./android/app/src/main/res');
   
   // 產生ios圖片
   generator.generateIosIcon(iconFile.readAsBytesSync(), iosDir);
   
   // 產生android圖片
   generator.generateAndroidIcon(iconFile.readAsBytesSync(), androidDir);
}
```

#### 2. Use this package as an executable
1. Activating a package

        dart pub global activate mx_app_icon

2. Running

        mx_app_icon -f {imagePath} -p ios -t {targetDir}

3. Command Line Arguments
    ```shell script
    -f, --file           image source file
    -t, --target_dir     target folder points to 'AppIcon.appiconset' for iOS and 'res' for Android.
    -p, --platform       platform (ios/android)
    -h, --[no-]help      description
    ```

(If thrown error `command not found` on step2, check [this](https://dart.cn/tools/pub/cmd/pub-global) add path to env) 
