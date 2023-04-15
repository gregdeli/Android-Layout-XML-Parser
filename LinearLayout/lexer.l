%{
#include "parser.tab.h"
%}

%%

"<LinearLayout"    { return T_OPEN_TAG; }
"/>"               { return T_CLOSE_TAG; }
">"                { return T_GT; }
"</LinearLayout>"  { return T_CLOSE_OPEN_TAG; }
"android:layout_width" { return T_LAYOUT_WIDTH; }
"android:layout_height" { return T_LAYOUT_HEIGHT; }
"android:id" { return T_ID; }
"android:orientation" { return T_ORIENTATION; }
"="                { return T_EQUAL; }
[0-9]+             { yylval.int_val = atoi(yytext); return T_POSITIVE_INT; }
\"[^\"]+\"         { yylval.str_val = strdup(yytext + 1); yylval.str_val[strlen(yytext)-2] = '\0'; return T_STRING; }
[ \t\n\r\f]+       ; /* ignore whitespace */

.                  { fprintf(stderr, "Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
