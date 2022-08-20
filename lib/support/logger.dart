import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 8,
  ),
  output: MyLogOutput(),
);

class MyLogOutput extends LogOutput {
  ConsoleOutput consoleOutput = ConsoleOutput();
  @override
  void output(OutputEvent event) {
    List<String> list = [];

    for (int i = 0; i < event.lines.length; i++) {
      list.add(event.lines[i].replaceAll('─', ''));
      list[i] = list[i].replaceAll('┄', '');
    }
    FirebaseCrashlytics.instance.log(list.toString());
    consoleOutput.output(event);
  }
}
