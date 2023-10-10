import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

typedef EntryBuilder = MapEntry Function({required String name});

Map<String, dynamic> _updateDependencies({
  required Map<String, dynamic> map,
  String prefix = 'mhc_',
  required EntryBuilder entryBuilder,
}) {
  final newMap = <String, dynamic>{};
  for (final pair in map.entries) {
    final name = pair.key;
    if (!name.startsWith(prefix)) {
      newMap[name] = pair.value;
    } else {
      newMap[name] = Map.fromEntries([entryBuilder(name: name)]);
    }
  }
  return newMap;
}

Map<String, dynamic> _setDependenciesToGit({
  required Map<String, dynamic> map,
  required String repository,
  String prefix = 'mhc_',
}) {
  return _updateDependencies(
    map: map,
    entryBuilder: ({required name}) {
      return MapEntry('git', {
        'url': '$repository.git',
        'path': 'packages/$name',
      });
    },
  );
}

Map<String, dynamic> _setDependenciesToPath({
  required Map<String, dynamic> map,
  required String repository,
  String prefix = 'mhc_',
}) {
  return _updateDependencies(
    map: map,
    entryBuilder: ({required name}) {
      return MapEntry('path', './../$name');
    },
  );
}

String setDependenciesToGit({
  required YamlMap yaml,
  required YamlEditor yamlEditor,
  required String repository,
  String prefix = 'mhc_',
}) {
  final name = yaml['name'] as String;
  final dependenciesYamlMap = yaml['dependencies'];
  final devDependenciesYamlMap = yaml['dev_dependencies'];
  if (dependenciesYamlMap is YamlMap) {
    final dependenciesMapEntries = dependenciesYamlMap.entries
        .map((e) => MapEntry<String, dynamic>(e.key as String, e.value))
        .toList();
    final dependenciesMap =
        Map<String, dynamic>.fromEntries(dependenciesMapEntries);
    final newDependenciesMap = _setDependenciesToGit(
      map: dependenciesMap,
      repository: repository,
    );
    yamlEditor.update(const ['dependencies'], newDependenciesMap);
  }
  if (devDependenciesYamlMap is YamlMap) {
    final devDependenciesMapEntries = devDependenciesYamlMap.entries
        .map((e) => MapEntry<String, dynamic>(e.key as String, e.value))
        .toList();
    final devDependenciesMap =
        Map<String, dynamic>.fromEntries(devDependenciesMapEntries);
    final newDevDependenciesMap = _setDependenciesToGit(
      map: devDependenciesMap,
      repository: repository,
    );
    yamlEditor.update(const ['dev_dependencies'], newDevDependenciesMap);
  }
  return yamlEditor.toString();
}

class DeployCommand extends Command {
  @override
  String get description => 'no description';

  @override
  String get name => 'deploy';

  @override
  void run() {
    final directories = packageDirectories();
    final names = directories.map(basename).toList();

    print('packages: ');
    for (final packageName in names) {
      print(packageName);
    }

    final myYaml = getMyYaml();
    final myRepository = myYaml['repository'] as String;
    print('myRepository: $myRepository');

    for (final packageDirectory in directories) {
      final packageYamlFile = File(join(packageDirectory, 'pubspec.yaml'));
      final packageYamlString = packageYamlFile.readAsStringSync();
      final packageYaml = loadYaml(packageYamlString) as YamlMap;
      final packageYamlEditor = YamlEditor(packageYamlString);

      setDependenciesToGit(
        yaml: packageYaml,
        yamlEditor: packageYamlEditor,
        repository: myRepository,
      );

      packageYamlFile.writeAsStringSync(packageYamlEditor.toString());
    }
  }

  List<String> packageDirectories() {
    final currentPath = Directory.current.path;
    final packagesDirectory = Directory(join(currentPath, 'packages'));
    return packagesDirectory
        .listSync()
        .whereType<Directory>()
        .map((e) => e.path)
        .toList();
  }

  YamlMap getMyYaml() {
    return loadYaml(
      File(join(Directory.current.path, 'pubspec.yaml')).readAsStringSync(),
    ) as YamlMap;
  }
}
