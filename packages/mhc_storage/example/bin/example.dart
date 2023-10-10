import 'dart:io';

import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';

void main(List<String> arguments) {
  final current = Directory.current;
  final hive = Directory(join(current.path, 'hive'));
  Isar.initialize('./libs/libisar_macos.dylib');
  Hive.defaultDirectory = hive.path;

  final box = Hive.box();

  box.watchKey('key').listen((event) {
    print('event: $event');
  });

  box.put('key', 123);
}
