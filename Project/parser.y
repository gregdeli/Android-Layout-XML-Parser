%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *);
FILE *yyin;
%}

%token LIN_LAYOUT_OPEN_TAG GT LIN_LAYOUT_CLOSE_TAG
%token LAYOUT_WIDTH LAYOUT_HEIGHT ID ORIENTATION EQUAL
%token POSITIVE_INT STRING
%token TEXT_OPEN_TAG CLOSE_TAG TEXT TEXT_COLOR
%token IMAGE_OPEN_TAG SRC PADDING

%union{
	char str[20];
    int pos_int;
}

%type <pos_int> POSITIVE_INT
%type <str> STRING

%start layout

%%
layout : lin_layout
       ;

lin_layout :  LIN_LAYOUT_OPEN_TAG lin_layout_attr GT lin_layout_content LIN_LAYOUT_CLOSE_TAG
       ;

lin_layout_attr : mandatory_attr lin_layout_opt_attr
                ;

mandatory_attr : LAYOUT_WIDTH EQUAL STRING LAYOUT_HEIGHT EQUAL STRING
               | LAYOUT_WIDTH EQUAL STRING LAYOUT_HEIGHT EQUAL POSITIVE_INT
               | LAYOUT_WIDTH EQUAL POSITIVE_INT LAYOUT_HEIGHT EQUAL STRING
               | LAYOUT_WIDTH EQUAL POSITIVE_INT LAYOUT_HEIGHT EQUAL POSITIVE_INT
               ;

lin_layout_opt_attr : ID EQUAL STRING ORIENTATION EQUAL STRING
                    | ORIENTATION EQUAL STRING ID EQUAL STRING
                    | ID EQUAL STRING
                    | ORIENTATION EQUAL STRING
                    | /* empty */
                    ;

lin_layout_content : element
                   | lin_layout_content element
                   | /*empty*/
                   ;

element : lin_layout 
        | text_view
        | image_view
        ;

text_view : TEXT_OPEN_TAG text_attr CLOSE_TAG 
          ;

text_attr : mandatory_attr TEXT EQUAL STRING text_opt_attr
          ;

text_opt_attr : ID EQUAL STRING TEXT_COLOR EQUAL STRING
              | TEXT_COLOR EQUAL STRING ID EQUAL STRING
              | ID EQUAL STRING
              | TEXT_COLOR EQUAL STRING
              | /* empty */
              ;

image_view : IMAGE_OPEN_TAG image_attr CLOSE_TAG    
           ;

image_attr : mandatory_attr SRC EQUAL STRING image_opt_attr
           ;

image_opt_attr : ID EQUAL STRING PADDING EQUAL POSITIVE_INT
              | POSITIVE_INT EQUAL POSITIVE_INT ID EQUAL STRING
              | ID EQUAL STRING
              | PADDING EQUAL POSITIVE_INT
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
