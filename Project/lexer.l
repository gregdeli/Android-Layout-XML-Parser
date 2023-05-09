%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(const char *);
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

"<!--"[^-]*(-[^-]+)*"-->" { return COMMENT; }   

"="                { return EQUAL; }
\"[0-9]+\"         { yylval.pos_int = atoi(yytext); return POSITIVE_INT; }
\"[^\"\n]*\"       { sscanf(yytext, "%s", yylval.str); return STRING; }
[ \t\n\r\f]+       ; /* ignore whitespace */
.                  { yyerror("Invalid character"); }

%%
void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\nAt line: %d\n", msg,yylineno);
    exit(1);
}

int yywrap(void) {
    return 1;
} 