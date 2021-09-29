package com.craftinginterpreters.lox;

class Token {
	final TokenType type;
	final String lexeme;
	final Object literal;
	final int line;

	Token(TokenType type, String lexeme, Object literal, int line) {
		this.type = type;
		this.lexeme = lexeme;
		this.literal = literal;
		this.line = line;
	}

	public String toString() {
		return type + " " + lexeme + " " + literal;
	}

	public boolean equals(Object t) {
		Token tok = (Token) t;
		boolean sameType = this.type.equals(tok.type);
		boolean sameLexeme = this.lexeme.equals(tok.lexeme);
		boolean sameLiteral = this.literal == tok.literal;
		boolean sameLine = this.line == tok.line;

		return sameType && sameLexeme && sameLiteral && sameLine;
	}
}
