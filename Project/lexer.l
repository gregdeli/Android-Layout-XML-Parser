%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(const char *);
void remove_quotes(char *);
%}

%option yylineno

%%

"<LinearLayout"         { return LIN_LAYOUT_OPEN_TAG; }
">"                     { return GT; }
"/>"                    { return CLOSE_TAG; }
"</LinearLayout>"       { return LIN_LAYOUT_CLOSE_TAG; }
"android:layout_width"  { return LAYOUT_WIDTH; }
"android:layout_height" { return LAYOUT_HEIGHT; }
"android:id"            { return ID; }
"android:orientation"   { return ORIENTATION; }

"<RelativeLayout"    {return RE_LAYOUT_OPEN_TAG; }
"</RelativeLayout>"  { return RE_LAYOUT_CLOSE_TAG; }

"<TextView"          { return TEXT_OPEN_TAG; }
"android:text"       { return TEXT; }
"android:textColor"  { return TEXT_COLOR; }

"<ImageView"       { return IMAGE_OPEN_TAG; }
"android:src"      { return SRC; }
"android:padding"  { return PADDING; }

"<Button"  { return BUTTON_OPEN_TAG; }

"<RadioGroup"            { return R_GROUP_OPEN_TAG; }
"</RadioGroup>"          { return R_GROUP_CLOSE_TAG; }
"<RadioButton"           {return R_BUTTON_OPEN_TAG; }
"android:checkedButton"  { return CHECKED_BUTTON; }

"<ProgressBar"     {return PRO_BAR_OPEN_TAG; }
"android:max"      {return MAX; }
"android:progress" {return PROGRESS; }

"<!--"[^-]*(-[^-]+)*"-->" /* Ignore comments */  

"="                { return EQUAL; }
\"-?[0-9]+\"         { remove_quotes(yytext); yylval.pos_int = atoi(yytext); return POSITIVE_INT; }
\"[^\"\n]*\"       { /*printf("%s\n", yytext);*/ sscanf(yytext, "%s", yylval.str); return STRING; }

[ \t\n\r\f]+       ; /* Ignore whitespace */
.                  { yyerror("Invalid character"); }

%%
void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\nAt line: %d\n", msg,yylineno);
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

int yywrap(void) {
    return 1;
} 