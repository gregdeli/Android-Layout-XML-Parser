%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%

"<LinearLayout"    { return OPEN_TAG; }
">"                { return GT; }
"</LinearLayout>"  { return CLOSE_OPEN_TAG; }
"android:layout_width" { return LAYOUT_WIDTH; }
"android:layout_height" { return LAYOUT_HEIGHT; }
"android:id" { return ID; }
"android:orientation" { return ORIENTATION; }
"="                { return EQUAL; }
[0-9]+             { yylval.pos_int = atoi(yytext); return POSITIVE_INT; }
\"[^\"\n]*\"       { sscanf(yytext, "%s", yylval.str); return STRING; }
[ \t\n\r\f]+       ; /* ignore whitespace */
.                  { showError(); }

%%

int yywrap(void) {
    return 1;
} 

void showError(){
    printf("Unknown input\n");
    exit(1);
}