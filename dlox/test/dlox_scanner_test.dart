import 'package:dlox/src/scanner.dart';
import 'package:dlox/src/token.dart';
import 'package:dlox/src/token_type.dart';
import 'package:test/test.dart';

void main() {
  group('scanner can parse numbers', () {
    test('can parse 0', () {
      var scanner = Scanner('0');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.NUMBER, '0', 0, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });

    test('can parse integers', () {
      var scanner = Scanner('2');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.NUMBER, '2', 2, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });

    test('can parse long numbers', () {
      var scanner = Scanner('2324945.213412');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.NUMBER, '2324945.213412', 2324945.213412, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });

    test('can parse doubles', () {
      var scanner = Scanner('2.3');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.NUMBER, '2.3', 2.3, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });
  });

  group('can parse strings and identifier', () {
    test('can parse identifiers', () {
      var scanner = Scanner('variable');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.IDENTIFIER, 'variable', null, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });

    test('can parse an empty string', () {
      var scanner = Scanner('""');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.STRING, '""', '', 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });

    test('can parse non-empty strings', () {
      var scanner = Scanner('"un string"');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.STRING, '"un string"', 'un string', 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });
  });

  group('can parse operators', () {
    test('can parse arithmetic operators', () {
      var scanner = Scanner('+-*');
      var tokens = scanner.scanTokens();
      var expected = [
        Token(TokenType.PLUS, '+', null, 1),
        Token(TokenType.MINUS, '-', null, 1),
        Token(TokenType.STAR, '*', null, 1),
        Token(TokenType.EOF, '', null, 1),
      ];
      expect(expected, tokens);
    });
  });
}
