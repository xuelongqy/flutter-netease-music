import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 路径
const String UNLOCK_PATH = '/data/unlock';
/// 程序路径
const String UNLOCK_APP_PATH = UNLOCK_PATH + '/index.js';

/// unlock 环境
class UnlockEnvironment {
  /// 初始化环境
  static Future<bool> init() async {
    var path = Directory((await getApplicationDocumentsDirectory()).path + UNLOCK_PATH);
    if (!path.existsSync()) {
      path.createSync(recursive: true);
    }
    var bytes = await rootBundle.load('assets/unlock/unblock_netease_music_server.zip');
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    for (final file in archive) {
      final filename = file.name;
      print('${path.path}/' + filename);
      if (file.isFile) {
        final data = file.content as List<int>;
        File('${path.path}/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('${path.path}/' + filename)
          ..createSync(recursive: true);
      }
    }
    return Future.value(true);
  }
}