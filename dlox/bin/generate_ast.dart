import 'dart:io';

void main(List<String> args) {
  GenerateAst.main(args);
}

class GenerateAst {
  static void main(List<String> args) {
    if (args.length != 1) {
      print('Usage: generate_ast <output_directory>');
      exit(64);
    }
    var outputDir = args[0];
    defineAst(outputDir, 'Expr', [
      'Binary : Expr left, Token operator, Expr right',
      'Grouping : Expr expression',
      'Literal : Object value',
      'Unary : Token operator, Expr right'
    ]);
  }

  static void defineAst(String outputDir, String baseName, List<String> types) {
    var path = '$outputDir/${baseName.toLowerCase()}.dart';
    var writer = StringBuffer();

    writer.writeln("import 'package:dlox/src/token.dart';");
    writer.writeln();

    defineVisitor(writer, baseName, types);

    writer.writeln('abstract class $baseName<R> {');

    // The base accept() method.
    writer.writeln('  R accept(Visitor<R> visitor);');
    writer.writeln('}');
    writer.writeln();

    // The AST classes.
    for (var type in types) {
      var className = type.split(':')[0].trim();
      var fields = type.split(':')[1].trim();
      defineType(writer, baseName, className, fields);
      writer.writeln();
    }

    var file = File(path);
    file.writeAsStringSync(writer.toString());
  }

  static void defineVisitor(
      StringBuffer writer, String baseName, List<String> types) {
    writer.writeln('abstract class Visitor<R> {');

    for (var type in types) {
      var typeName = type.split(':')[0].trim();
      writer.writeln(
          '  R visit$typeName$baseName($typeName ${baseName.toLowerCase()});');
    }
    writer.writeln('}');
    writer.writeln();
  }

  static void defineType(StringBuffer writer, String baseName, String className,
      String fieldList) {
    writer.writeln('class $className<R> extends $baseName<R> {');
    var fields = fieldList.split(', ');

    // Fields.
    for (var field in fields) {
      writer.writeln('  final $field;');
    }

    writer.writeln();

    // Constructor.
    writer.write('  $className(');

    // Store parameters in fields.
    for (var field in fields) {
      var name = field.split(' ')[1];
      writer.write('this.$name,');
    }
    writer.writeln(');');

    // Visitor pattern.
    writer.writeln();
    writer.writeln('  @override');
    writer.writeln('  R accept(Visitor<R> visitor) {');
    writer.writeln('    return visitor.visit$className$baseName(this);');
    writer.writeln('  }');

    writer.writeln('}');
  }
}
