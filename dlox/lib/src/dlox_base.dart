import 'dart:io' as io;
import 'package:dlox/src/scanner.dart';

class Lox {
  static bool hadError = false;

  static void main(List<String> args) {
    if (args.length > 1) {
      print('Usage: jlox [script]');
      io.exit(64);
    } else if (args.length == 1) {
      runFile(args[0]);
    } else {
      runPrompt();
    }
  }

  static void runFile(String path) {
    // byte[] bytes = Files.readAllBytes(Paths.get(path));
    // run(new String(bytes, Charset.defaultCharset()));
    if (hadError) {
      io.exit(65);
    }
  }

  static void runPrompt() {
    // InputStreamReader input = new InputStreamReader(System.in);
    // BufferedReader reader = new BufferedReader(input);
    // leer por comsola
    for (;;) {
      print('> ');
      String? line = reader.readLine();
      // When the user types Ctrl+D line is null
      if (line == null) {
        break;
      }
      run(line);
      hadError = false;
    }
  }

  static void run(String source) {
    var scanner = Scanner(source);
    var tokens = scanner.scanTokens();
    print(tokens);
  }

  static void error(int line, String message) {
    report(line, '', message);
  }

  static void report(int line, String where, String message) {
    print('[line' + line.toString() + '] Error' + where + ': ' + message);
    hadError = true;
  }
}
