all:
	flex -l lexer.l
	bison -d parser.y 
	gcc lex.yy.c parser.tab.c -o xml_parser

clean:
	rm -f *.tab.c *.tab.h *.yy.c *.output xml_parser
