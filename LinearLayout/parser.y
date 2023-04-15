%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *);
%}
%union{
	char str[20];
    int pos_int;
}

%token T_OPEN_TAG T_CLOSE_TAG T_GT T_CLOSE_OPEN_TAG
%token T_LAYOUT_WIDTH T_LAYOUT_HEIGHT T_ID T_ORIENTATION T_EQUAL
%token <pos_int> POSITIVE_INT
%token <str> STRING

%start element

%%

element : T_OPEN_TAG attributes T_GT content T_CLOSE_OPEN_TAG | T_CLOSE_TAG
        ;

attributes : mandatory_attributes optional_attributes?
           ;

mandatory_attributes : T_LAYOUT_WIDTH T_EQUAL (STRING | POSITIVE_INT) T_LAYOUT_HEIGHT T_EQUAL (STRING | POSITIVE_INT)
                     ;

optional_attributes : T_ID T_EQUAL STRING? T_ORIENTATION T_EQUAL STRING?
                    | T_ORIENTATION T_EQUAL STRING? T_ID T_EQUAL STRING?
                    | /* empty */
                    ;

content : line+
        ;

line : STRING
     ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    exit(1);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Failed to open input file");
        return 1;
    }

    yyin = input_file;

    yyparse();

    fclose(input_file);

    return 0;
}
