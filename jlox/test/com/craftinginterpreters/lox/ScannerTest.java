package com.craftinginterpreters.lox;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertIterableEquals;
import static com.craftinginterpreters.lox.TokenType.*;

public class ScannerTest {
	@Test
	void testCanScanOperators() {
		Scanner scanner = new Scanner("+-");
		List<Token> tokens = scanner.scanTokens();
		List<Token> expected = Arrays.asList(
			new Token(PLUS, "+", null, 1),
			new Token(MINUS, "-", null, 1),
			new Token(EOF, "", null, 1));
		assertIterableEquals(expected, tokens);
	}
}
