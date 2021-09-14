import 'package:dlox/src/token.dart';
import 'package:dlox/src/token_type.dart';
import 'package:dlox/src/dlox_base.dart';

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
    while (!isAtEnd()) {
      // We are at the beginning of the current lexeme.
      start = current;
      scanToken();
    }

    tokens.add(Token(TokenType.EOF, '', null, line));
    return tokens;
  }

  void scanToken() {
    var c = advance();
    switch (c) {
      case '(':
        addToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        addToken(TokenType.RIGHT_PAREN);
        break;
      case '{':
        addToken(TokenType.LEFT_BRACE);
        break;
      case '}':
        addToken(TokenType.RIGHT_BRACE);
        break;
      case ',':
        addToken(TokenType.COMMA);
        break;
      case '.':
        addToken(TokenType.DOT);
        break;
      case '-':
        addToken(TokenType.MINUS);
        break;
      case '+':
        addToken(TokenType.PLUS);
        break;
      case ';':
        addToken(TokenType.SEMICOLON);
        break;
      case '*':
        addToken(TokenType.STAR);
        break;
      case '!':
        addToken(match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
        break;
      case '=':
        addToken(match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case '<':
        addToken(match('=') ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case '>':
        addToken(match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case '/':
        if (match('/')) {
          // A comment goes until the end of the line.
          while (peek() != '\n' && !isAtEnd()) {
            advance();
          }
        } else {
          addToken(TokenType.SLASH);
        }
        break;
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      case '\n':
        line++;
        break;
      case '"':
        string();
        break;
      default:
        if (isDigit(c)) {
          number();
        } else if (isAlpha(c)) {
          identifier();
        } else {
          Lox.error(line, 'Unexpected character.');
        }
        break;
    }
  }

  void identifier() {
    while (isAlphaNumeric(peek())) {
      advance();
    }

    var text = source.substring(start, current);
    var type = keywords[text];
    type ??= TokenType.IDENTIFIER;
    addToken(type);
  }

  void number() {
    while (isDigit(peek())) {
      advance();
    }

    // Look for a fractional part.
    if (peek() == '.' && isDigit(peekNext())) {
      // Consume the "."
      advance();

      while (isDigit(peek())) {
        advance();
      }
    }
    addToken(TokenType.NUMBER, double.parse(source.substring(start, current)));
  }

  void string() {
    while (peek() != '"' && !isAtEnd()) {
      if (peek() == '\n') line++;
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

  bool match(String expected) {
    if (isAtEnd()) return false;
    if (String.fromCharCode(source.codeUnitAt(current)) != expected) {
      return false;
    }

    current++;
    return true;
  }

  String peek() {
    if (isAtEnd()) return '\x00';
    return String.fromCharCode(source.codeUnitAt(current));
  }

  String peekNext() {
    if (current + 1 >= source.length) {
      return '\x00';
    }
    return String.fromCharCode(source.codeUnitAt(current + 1));
  }

  bool isAlpha(String c) {
    var isDownCaseLetter = (c.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
        c.codeUnitAt(0) <= 'z'.codeUnitAt(0));
    var isUpperCaseLetter = (c.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
        c.codeUnitAt(0) <= 'Z'.codeUnitAt(0));
    var isUnderscore = c.codeUnitAt(0) == '_'.codeUnitAt(0);
    return isDownCaseLetter || isUpperCaseLetter || isUnderscore;
  }

  bool isAlphaNumeric(String c) {
    return isAlpha(c) || isDigit(c);
  }

  bool isDigit(String c) {
    return c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  }

  /// Advances **current** to the next character in **source** and returns it.
  String advance() {
    return String.fromCharCode(source.codeUnitAt(current++));
  }

  void addToken(TokenType type, [Object? literal]) {
    var text = source.substring(start, current);
    tokens.add(Token(type, text, literal, line));
  }

  bool isAtEnd() {
    return current >= source.length;
  }
}
