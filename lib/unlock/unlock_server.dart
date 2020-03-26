import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter_node/node_bindings.dart';
import 'package:path_provider/path_provider.dart';

import 'unlock_environment.dart';
import 'match_entity.dart';

/// 请求地址
const String MATCH_PATH = 'http://127.0.0.1:1371/match';

/// unlock 服务
class UnlockServer {
  /// 启动服务
  static Future<bool> start() async {
    await UnlockEnvironment.init();
    await _startNode();
    return true;
  }

  /// 启动node
  static Future<bool> _startNode() async {
    List<String> arguments = [
      'node',
      (await getApplicationDocumentsDirectory()).path + UNLOCK_APP_PATH,
    ];
    Pointer<Pointer<Utf8>> argv = allocate<Pointer<Utf8>>(count: arguments.length);
    int argumentsSize = 0;
    for (var arg in arguments) {
      int size = utf8.encode(arg).length + 1;
      argumentsSize += size;
    }
    Pointer<Utf8> argumentsPointer;
    final Pointer<Uint8> result = allocate<Uint8>(count: argumentsSize);
    final Uint8List nativeString = result.asTypedList(argumentsSize);
    argumentsPointer = result.cast();
    int argumentsPos = 0;
    for (int i = 0; i < arguments.length; i++) {
      var arg = arguments[i];
      var units = utf8.encode(arg);
      nativeString.setAll(argumentsPos, units);
      nativeString[argumentsPos + units.length] = 0;
      argv[i] = Pointer.fromAddress(argumentsPos + argumentsPointer.address);
      argumentsPos += units.length + 1;
    }
    // 启动Node程序
    nodeStartThread(arguments.length, argv, nullptr);
    return true;
  }

  /// 匹配歌曲
  static Future<MatchEntity> match(int id) async {
    var request = await HttpClient().getUrl(Uri.parse('$MATCH_PATH?id=$id'));
    var response = await request.close();
    var data = await response.transform(utf8.decoder).join();
    return MatchEntity.fromJsonMap(JsonCodec().decode(data));
  }
}