%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

int yylex();
void yyerror(const char *);
extern FILE *yyin;
void insert_id(char *str);
bool check_id(char *str);
typedef struct node {
    char *id;
    struct node *next;
} Node;
Node *head = NULL;
%}

%token LIN_LAYOUT_OPEN_TAG GT LIN_LAYOUT_CLOSE_TAG 
%token RE_LAYOUT_OPEN_TAG RE_LAYOUT_CLOSE_TAG
%token LAYOUT_WIDTH LAYOUT_HEIGHT ID ORIENTATION EQUAL
%token POSITIVE_INT STRING
%token TEXT_OPEN_TAG CLOSE_TAG TEXT TEXT_COLOR
%token IMAGE_OPEN_TAG SRC PADDING
%token BUTTON_OPEN_TAG R_GROUP_OPEN_TAG R_GROUP_CLOSE_TAG R_BUTTON_OPEN_TAG CHECKED_BUTTON
%token PRO_BAR_OPEN_TAG MAX PROGRESS
%token COMMENT

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

mandatory_attr : layout_width_attr layout_heigth_attr
               | layout_heigth_attr layout_width_attr
               ;

lin_layout_opt_attr : id_attr ORIENTATION EQUAL STRING
                    | ORIENTATION EQUAL STRING id_attr
                    | id_attr
                    | ORIENTATION EQUAL STRING
                    | /* empty */
                    ;

id_attr : ID EQUAL STRING { insert_id($3); }
        ;

layout_width_attr: LAYOUT_WIDTH EQUAL STRING {
                        if(!((strcmp($3, "\"match_parent\"") == 0) || (strcmp($3, "\"wrap_content\"") == 0))){
                        char err_msg[] = "Invalid android:layout_width = ";
                        strcat(err_msg, $3);
                        yyerror(err_msg); 
                        }
                    }
                | LAYOUT_WIDTH EQUAL POSITIVE_INT {
                        printf("\n%d", $3); //del
                        if(($3<0)){
                            char err_msg[] = "Invalid android:layout_width = ";
                            printf(err_msg, "%d", $3);
                            yyerror(err_msg); 
                        }
                  }
                ;

layout_heigth_attr: LAYOUT_HEIGHT EQUAL STRING{
                        if(!((strcmp($3, "\"match_parent\"") == 0) || (strcmp($3, "\"wrap_content\"") == 0))){
                            char err_msg[] = "Invalid android:layout_height = ";
                            strcat(err_msg, $3);
                            yyerror(err_msg); 
                            }
                    }
                  | LAYOUT_HEIGHT EQUAL POSITIVE_INT{
                        if(($3<0)){
                            char err_msg[] = "Invalid android:layout_height = ";
                            printf(err_msg, "%d", $3);
                            yyerror(err_msg); 
                        }
                    }
                  ;

lin_layout_content : element
                   | lin_layout_content element
                   | /*empty*/
                   ;

re_layout : RE_LAYOUT_OPEN_TAG re_layout_attr GT re_layout_content RE_LAYOUT_CLOSE_TAG
          ;

re_layout_attr : mandatory_attr re_layout_opt_attr
               ;

re_layout_opt_attr : id_attr
                   | /* empty */
                   ;

re_layout_content : element
                  | re_layout_content element
                  | /* empty */
                  ;

element : lin_layout 
        | re_layout
        | text_view
        | image_view
        | button
        | radio_group
        | pro_bar
        ;

text_view : TEXT_OPEN_TAG text_attr CLOSE_TAG 
          ;

text_attr : mandatory_attr TEXT EQUAL STRING text_opt_attr
          | TEXT EQUAL STRING mandatory_attr text_opt_attr
          ;

text_opt_attr : id_attr TEXT_COLOR EQUAL STRING
              | TEXT_COLOR EQUAL STRING id_attr
              | id_attr
              | TEXT_COLOR EQUAL STRING
              | /* empty */
              ;

image_view : IMAGE_OPEN_TAG image_attr CLOSE_TAG    
           ;

image_attr : mandatory_attr SRC EQUAL STRING image_and_button_opt_attr
           ;

image_and_button_opt_attr : id_attr PADDING EQUAL POSITIVE_INT
                        | PADDING EQUAL POSITIVE_INT id_attr
                        | id_attr
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

r_group_opt_attr : id_attr CHECKED_BUTTON EQUAL STRING
              | CHECKED_BUTTON EQUAL STRING id_attr
              | id_attr
              | CHECKED_BUTTON EQUAL STRING
              | /* empty */
              ;

r_group_content : radio_button
                | r_group_content radio_button
                | COMMENT
                ;

radio_button : R_BUTTON_OPEN_TAG radio_button_attr CLOSE_TAG 
             ;

radio_button_attr : mandatory_attr TEXT EQUAL STRING radio_button_opt_attr
                  ;

radio_button_opt_attr : id_attr
              | /* empty */
              ;

pro_bar : PRO_BAR_OPEN_TAG pro_bar_attr CLOSE_TAG;

pro_bar_attr: mandatory_attr pro_bar_opt_attr
            ;

pro_bar_opt_attr: id_attr
                | MAX EQUAL POSITIVE_INT
                | PROGRESS EQUAL POSITIVE_INT

                | id_attr MAX EQUAL POSITIVE_INT
                | MAX EQUAL POSITIVE_INT id_attr
                | id_attr PROGRESS EQUAL POSITIVE_INT
                | PROGRESS EQUAL POSITIVE_INT id_attr
                | MAX EQUAL POSITIVE_INT PROGRESS EQUAL POSITIVE_INT
                | PROGRESS EQUAL POSITIVE_INT MAX EQUAL POSITIVE_INT

                | id_attr MAX EQUAL POSITIVE_INT PROGRESS EQUAL POSITIVE_INT
                | id_attr PROGRESS EQUAL POSITIVE_INT MAX EQUAL POSITIVE_INT 
                | MAX EQUAL POSITIVE_INT id_attr PROGRESS POSITIVE_INT
                | MAX EQUAL POSITIVE_INT PROGRESS EQUAL POSITIVE_INT id_attr
                | PROGRESS EQUAL POSITIVE_INT id_attr MAX EQUAL POSITIVE_INT
                | PROGRESS EQUAL POSITIVE_INT MAX EQUAL POSITIVE_INT id_attr
                | /* empty */
                ;


%%

void insert_id(char *str)
{
    //Eisagvgi you id string stin lista
    Node *newNode = malloc(sizeof(Node));
    newNode->id = malloc((strlen(str) + 1) * sizeof(char));
    strcpy(newNode->id, str);
    newNode->next = head;
    head = newNode;

    bool id_exists = false;
    id_exists = check_id(str);

    if(id_exists)
    {
        char err_msg[] = "Duplicate android:id ";
        strcat(err_msg, str);
        yyerror(err_msg); 
    }
}

bool check_id(char *str)
{
    bool id_exists = false;

    Node *current = head->next;
    // diatrexw tin lista kai elegxw an to new id yphrxe
    while (current != NULL) {
        if(strcmp(current->id, str)==0)
            id_exists = true;
        current = current->next;
    }

    return id_exists;
}

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

    printf("\nThe file was succesfully parsed\n");

    fclose(input_file);

    return 0;
}