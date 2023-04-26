%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *);
FILE *yyin;
%}

%token LIN_LAYOUT_OPEN_TAG GT LIN_LAYOUT_CLOSE_TAG RE_LAYOUT_OPEN_TAG RE_LAYOUT_CLOSE_TAG
%token LAYOUT_WIDTH LAYOUT_HEIGHT ID ORIENTATION EQUAL
%token POSITIVE_INT STRING
%token TEXT_OPEN_TAG CLOSE_TAG TEXT TEXT_COLOR
%token IMAGE_OPEN_TAG SRC PADDING
%token BUTTON_OPEN_TAG R_GROUP_OPEN_TAG R_GROUP_CLOSE_TAG R_BUTTON_OPEN_TAG CHECKED_BUTTON

%union{
	char str[20];
    int pos_int;
}

%type <pos_int> POSITIVE_INT
%type <str> STRING

%locations

%start layout

%%
layout : lin_layout
       | re_layout
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

re_layout : RE_LAYOUT_OPEN_TAG re_layout_attr GT lin_layout_content RE_LAYOUT_CLOSE_TAG
          ;

re_layout_attr : mandatory_attr re_layout_opt_attr
               ;

re_layout_opt_attr : ID EQUAL STRING
                   | /* empty */
                   ;

element : lin_layout 
        | re_layout
        | text_view
        | image_view
        | button
        | radio_group
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

image_attr : mandatory_attr SRC EQUAL STRING image_and_button_opt_attr
           ;

image_and_button_opt_attr : ID EQUAL STRING PADDING EQUAL POSITIVE_INT
              | PADDING EQUAL POSITIVE_INT ID EQUAL STRING
              | ID EQUAL STRING
              | PADDING EQUAL POSITIVE_INT
              | /* empty */
              ;

button : BUTTON_OPEN_TAG button_attr CLOSE_TAG 
       ;

button_attr : mandatory_attr TEXT EQUAL STRING image_and_button_opt_attr
          ;

radio_group : R_GROUP_OPEN_TAG r_group_attr GT r_group_content R_GROUP_CLOSE_TAG    
           ;

r_group_attr : mandatory_attr r_group_opt_attr
           ;

r_group_opt_attr : ID EQUAL STRING CHECKED_BUTTON EQUAL STRING
              | CHECKED_BUTTON EQUAL STRING ID EQUAL STRING
              | ID EQUAL STRING
              | CHECKED_BUTTON EQUAL STRING
              | /* empty */
              ;

r_group_content : radio_button
                | r_group_content radio_button
                ;

radio_button : R_BUTTON_OPEN_TAG radio_button_attr CLOSE_TAG 
          ;

radio_button_attr : mandatory_attr TEXT EQUAL STRING radio_button_opt_attr
          ;

radio_button_opt_attr : ID EQUAL STRING
              | /* empty */
              ;
%%

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inpufile>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    char line[100];
    if (!input_file) {
        perror("Failed to open input file");
        return 1;
    }

    // ektypwsi olwn twn grammwn tou input file stin consola
    while (fgets(line, 100, input_file) != NULL) {
        printf("%s", line);
    }

    rewind(input_file); //gia na kanw reset ton file pointer meta tin ektypwsi tou arxeiou
    
    yyin = input_file;
    

    yyparse();
    printf("The file was succesfully parsed\n");

    fclose(input_file);

    return 0;
}
