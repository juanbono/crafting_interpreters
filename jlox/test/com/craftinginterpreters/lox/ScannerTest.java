package com.craftinginterpreters.lox;

import java.util.List;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

// TODO: actually implements the tests
// fijarme como implementar los tests sin exponer todas las clases
// del package como publicas
public class ScannerTest {
	@Test
	void testCanScanOperators() {
		Scanner scanner = new Scanner("+");
		List<Token> tokens = scanner.scanTokens();
		assertEquals(4, 2 + 2);
	}
}
