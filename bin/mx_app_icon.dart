import 'dart:io';

import 'package:args/args.dart';
import 'package:mx_app_icon/mx_app_icon.dart' as mx_app_icon;

void main(List<String> arguments) {
  final generator = mx_app_icon.MxAppIconGenerator();

  final parser = _initArgParser();
  final ArgResults result;
  try {
    result = parser.parse(arguments);
  } on Exception catch (e) {
    _handleArgError(parser, e.toString());
    return;
  }

  final help = result['help'] as bool;
  if (help || result.arguments.isEmpty) {
    _handleArgError(parser);
  }

  final filePath = result['file'];
  final platform = result['platform'];
  final targetDir = result['target_dir'];

  if (targetDir == null || targetDir.isEmpty) {
    stderr.write('-d: 目標資料夾 為必填\n');
    return;
  }

  final dir = Directory(targetDir);

  if (filePath == null || filePath.isEmpty) {
    stderr.write('-f: 圖片檔案 為必填\n');
    return;
  }

  final file = File(filePath);

  if (!file.existsSync()) {
    stderr.write('在此路徑下無法找到圖片檔案: $filePath\n');
    return;
  }

  if (platform == null || platform.isEmpty) {
    stderr.write('-f: 生成平台為必填\n');
    return;
  }

  if (platform == 'ios') {
    // ios在產生圖片之前要先刪除已有的
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    generator.generateIosIcon(file.readAsBytesSync(), dir);
  } else if (platform == 'android') {
    generator.generateAndroidIcon(file.readAsBytesSync(), dir);
  } else {
    stderr.write('-p: 生成平台參數錯誤, 只允許 ios 或 android\n');
  }
}

void _handleArgError(ArgParser parser, [String? msg]) {
  if (msg != null) {
    stderr.write(msg);
  }
  stdout.write('\n參數:\n\t${parser.usage.replaceAll('\n', '\n\t')}\n');
  exit(1);
}

ArgParser _initArgParser() {
  return ArgParser()
    ..addOption('file', abbr: 'f', help: 'image來源檔案')
    ..addOption(
      'target_dir',
      abbr: 't',
      help: '目標資料夾, ios指向AppIcon.appiconset, android指向res',
    )
    ..addOption('platform', abbr: 'p', help: '平台 ios/android')
    ..addFlag('help', abbr: 'h', help: '說明');
}
