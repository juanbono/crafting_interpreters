import 'package:dlox/src/token_type.dart';

class Token {
  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line;

  Token(this.type, this.lexeme, this.literal, this.line);

  @override
  String toString() {
    var typeName = type.toString().split('.').last;
    return '$typeName $lexeme $literal';
  }

  @override
  bool operator ==(otherToken) {
    if (otherToken.runtimeType != Token) {
      return false;
    } else {
      var tok = otherToken as Token;
      var sameType = type == tok.type;
      var sameLexeme = lexeme == tok.lexeme;
      var sameLiteral = literal == tok.literal;
      var sameLine = line == tok.line;

      return sameType && sameLexeme && sameLiteral && sameLine;
    }
  }
}
