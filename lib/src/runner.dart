import 'package:args/command_runner.dart';

import 'commands/deploy.dart';

Future<void> run(List<String> arguments) {
  final runner = CommandRunner('mhc', 'no mhc description')
    ..addCommand(DeployCommand());
  return runner.run(arguments);
}
