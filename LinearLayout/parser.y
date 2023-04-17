%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *);
FILE *yyin;
%}

%token OPEN_TAG GT CLOSE_OPEN_TAG
%token LAYOUT_WIDTH LAYOUT_HEIGHT ID ORIENTATION EQUAL
%token POSITIVE_INT STRING

%union{
	char str[20];
    int pos_int;
}

%type <pos_int> POSITIVE_INT
%type <str> STRING

%start element

%%

element :  OPEN_TAG attributes  GT content CLOSE_OPEN_TAG
        ;

attributes : mandatory_attributes optional_attributes
           ;

mandatory_attributes : LAYOUT_WIDTH EQUAL STRING LAYOUT_HEIGHT EQUAL STRING
                     | LAYOUT_WIDTH EQUAL STRING LAYOUT_HEIGHT EQUAL POSITIVE_INT
                     | LAYOUT_WIDTH EQUAL POSITIVE_INT LAYOUT_HEIGHT EQUAL STRING
                     | LAYOUT_WIDTH EQUAL POSITIVE_INT LAYOUT_HEIGHT EQUAL POSITIVE_INT
                     ;

optional_attributes : ID EQUAL STRING ORIENTATION EQUAL STRING
                    | ORIENTATION EQUAL STRING ID EQUAL STRING
                    | ID EQUAL STRING
                    | ORIENTATION EQUAL STRING
                    | /* empty */
                    ;

content : line
        | content line 
        ;

line : STRING
     | /* empty */
     ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    exit(1);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inpufile>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Failed to open input file");
        return 1;
    }

    yyin = input_file;

    yyparse();
    printf("The file was succesfully parsed\n");

    fclose(input_file);

    return 0;
}
