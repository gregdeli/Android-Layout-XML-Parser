all:
	flex -l test.l
	bison -d test.y 
	gcc -o test test.tab.c lex.yy.c -lfl

clean:
	rm -f *.tab.c *.tab.h *.yy.c *.output test
