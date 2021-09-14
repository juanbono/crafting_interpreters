import 'dart:io';

import 'package:dlox/dlox.dart';

void main(List<String> args) {
  if (args.length > 1) {
    print('Usage: jlox [script]');
    exit(64);
  } else if (args.length == 1) {
    runFile(args[0]);
  } else {
    runPrompt();
  }
}

void runFile(String file) {}

void runPrompt() {}
