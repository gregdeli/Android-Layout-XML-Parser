%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(const char *);
void remove_quotes(char *);
extern int rb_number;
int rb_counter = 0;
void check_rb_num();
%}

%option yylineno

%%

"<LinearLayout"         { printf("%s", yytext); return LIN_LAYOUT_OPEN_TAG; }
">"                     { printf("%s", yytext); return GT; }
"/>"                    { printf("%s", yytext); return CLOSE_TAG; }
"</LinearLayout>"       { printf("%s", yytext); return LIN_LAYOUT_CLOSE_TAG; }
"android:layout_width"  { printf("%s", yytext); return LAYOUT_WIDTH; }
"android:layout_height" { printf("%s", yytext); return LAYOUT_HEIGHT; }
"android:id"            { printf("%s", yytext); return ID; }
"android:orientation"   { printf("%s", yytext); return ORIENTATION; }

"<RelativeLayout"    { printf("%s", yytext); return RE_LAYOUT_OPEN_TAG; }
"</RelativeLayout>"  { printf("%s", yytext); return RE_LAYOUT_CLOSE_TAG; }

"<TextView"          { printf("%s", yytext); return TEXT_OPEN_TAG; }
"android:text"       { printf("%s", yytext); return TEXT; }
"android:textColor"  { printf("%s", yytext); return TEXT_COLOR; }

"<ImageView"       { printf("%s", yytext); return IMAGE_OPEN_TAG; }
"android:src"      { printf("%s", yytext); return SRC; }
"android:padding"  { printf("%s", yytext); return PADDING; }

"<Button"  { printf("%s", yytext); return BUTTON_OPEN_TAG; }

"<RadioGroup"            { printf("%s", yytext); return R_GROUP_OPEN_TAG; }
"</RadioGroup>"          { check_rb_num(); printf("%s", yytext); return R_GROUP_CLOSE_TAG; }
"<RadioButton"           { rb_counter++; printf("%s", yytext); return R_BUTTON_OPEN_TAG; }
"android:checkedButton"  { printf("%s", yytext); return CHECKED_BUTTON; }
"android:rb_number"      { printf("%s", yytext); return RB_NUMBER; }

"<ProgressBar"     { printf("%s", yytext); return PRO_BAR_OPEN_TAG; }
"android:max"      { printf("%s", yytext); return MAX; }
"android:progress" { printf("%s", yytext); return PROGRESS; }

"<!--"[^-]*(-[^-]+)*"-->" { printf("%s", yytext); /* Ignore comments */ }  

"="                { printf("%s", yytext); return EQUAL; }
\"-?[0-9]+\"         { printf("%s", yytext); remove_quotes(yytext); yylval.pos_int = atoi(yytext); return POSITIVE_INT; }
\"[^\"\n]*\"       { printf("%s", yytext); sscanf(yytext, "%s", yylval.str); return STRING; }

[ \t\n\r\f]+       { printf("%s", yytext); /* Ignore whitespace */ } 
.                  { yyerror("Invalid character"); }

%%
void yyerror(const char *msg) {
    fprintf(stderr, "\nError: %s\nAt line: %d\n", msg,yylineno);
    exit(1);
}

void remove_quotes(char* str) {
    int length = strlen(str);
    
    // Check if the string is long enough to have quotes
    if (length >= 2 && str[0] == '"' && str[length - 1] == '"') {
        // Afairoume to arxiko quote kanontas shift mia thesi aristera olous tous xaraktires
        for (int i = 0; i < length - 1; i++) {
            str[i] = str[i + 1];
        }
        
        // Afairesi tou teliko quote thetontas stin thesi tou ton termatiko xaraktira
        str[length - 2] = '\0';
    }
}

void check_rb_num(){
    if(rb_counter>rb_number)
    {
        char err_msg[] = "Invalid number of RadioButton elements. They should be ";
        char str_rb_num[5];
        snprintf(str_rb_num, sizeof(str_rb_num), "%d", rb_number);
        strcat(err_msg, str_rb_num);
        yyerror(err_msg); 
    }
}

int yywrap(void) {
    return 1;
} 