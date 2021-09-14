
import 'package:dlox/src/token.dart';
import 'package:dlox/src/token_type.dart';

/// Scans through the **source** producing a list of tokens.
class Scanner {
  final String source;
  final List<Token> tokens = [];

  /// Points to the first character in the lexeme being scanned.
  int start = 0;

  /// Points at the character currently being considered.
  int current = 0;

  /// Tracks what **source** line **current** is on.
  int line = 1;

  static Map<String, TokenType> keywords = {
    'and': TokenType.AND,
    'class': TokenType.CLASS,
    'else': TokenType.ELSE,
    'false': TokenType.FALSE,
    'FOR': TokenType.FOR,
    'FUN': TokenType.FUN,
    'if': TokenType.IF,
    'nil': TokenType.NIL,
    'or': TokenType.OR,
    'print': TokenType.PRINT,
    'return': TokenType.RETURN,
    'super': TokenType.SUPER,
    'this': TokenType.THIS,
    'true': TokenType.TRUE,
    'var': TokenType.VAR,
    'while': TokenType.WHILE,
  };

  /// Creates a Scanner that is responsible for reading a piece of source code and
  /// turns it into a list of tokens.
  ///
  /// @param source The source code to be scanned.
  ///
  Scanner(this.source);

  List<Token> scanTokens() {
    return [];
  }

  	private void string() {
		while (peek() != '"' && !isAtEnd()) {
			if (peek() == '\n')
				line++;
			advance();
		}

		if (isAtEnd()) {
			Lox.error(line, 'Unterminated string.');
			return;
		}

		advance(); // The closing ".

		// Trim the surrounding quotes.
		var value = source.substring(start + 1, current - 1);
		addToken(TokenType.STRING, value);
	}

  bool match(int expected) {
    if (isAtEnd()) return false;
    if (source.codeUnitAt(current) != expected) return false;

    current++;
    return true;
  }

  int peek() {
    if (isAtEnd()) return '\0'.codeUnitAt(0);
    return source.codeUnitAt(current);
  }

  int peekNext() {
    if (current + 1 >= source.length) {
      return '\0'.codeUnitAt(0);
    }
    return source.codeUnitAt(current + 1);
  }

  bool isAlpha(int c) {
    return (c >= 'a'.codeUnitAt(0) && c <= 'z'.codeUnitAt(0)) ||
        (c >= 'A'.codeUnitAt(0) && c <= 'Z'.codeUnitAt(0)) ||
        c == '_'.codeUnitAt(0);
  }

  bool isAlphaNumeric(int c) {
    return isAlpha(c) || isDigit(c);
  }

  bool isDigit(int c) {
    return c >= 0 && c <= 9;
  }

  /// Advances **current** to the next character in **source** and returns it.
  int advance() {
    return source.codeUnitAt(current++);
  }

  void addSingleToken(TokenType type) {
    addToken(type, null);
  }

  void addToken(TokenType type, Object? literal) {
    var text = source.substring(start, current);
    tokens.add(Token(type, text, literal, line));
  }

  bool isAtEnd() {
    return current >= source.length;
  }
}
