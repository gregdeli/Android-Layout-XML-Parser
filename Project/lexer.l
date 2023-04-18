%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(const char *);
%}

%%

"<LinearLayout"    { return LIN_LAYOUT_OPEN_TAG; }
">"                { return GT; }
"/>"                 { return CLOSE_TAG; }
"</LinearLayout>"  { return LIN_LAYOUT_CLOSE_TAG; }
"android:layout_width"  { return LAYOUT_WIDTH; }
"android:layout_height" { return LAYOUT_HEIGHT; }
"android:id"            { return ID; }
"android:orientation" { return ORIENTATION; }
"<TextView"          { return TEXT_OPEN_TAG; }
"android:text"       { return TEXT; }
"android:textColor"  { return TEXT_COLOR; }
"<ImageView"       { return IMAGE_OPEN_TAG; }
"android:src"      { return SRC; }
"android:padding"  { return PADDING; }
"="                { return EQUAL; }
[0-9]+             { yylval.pos_int = atoi(yytext); return POSITIVE_INT; }
\"[^\"\n]*\"       { sscanf(yytext, "%s", yylval.str); return STRING; }
[ \t\n\r\f]+       ; /* ignore whitespace */
.                  { yyerror("Invalid character"); }


%%

int yywrap(void) {
    return 1;
} 