all:
	bison -d parser.y 
	flex -l lexer.l
	gcc lex.yy.c parser.tab.c -o xml_parser

clean:
	rm -f *.tab.c *.tab.h *.yy.c *.output xml_parser
