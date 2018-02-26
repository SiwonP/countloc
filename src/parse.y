%{
#include <stdio.h>
extern FILE *yyin;
int yylex(void);
int yyerror();
%}

%token STRING

%%

expression
: STRING

%%

extern int strings;
extern int spaces;

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    if ( yyparse() == 0) {
        printf("Success\n");
        printf("%d\n", strings);
    }
    return 1;
}

int yyerror()
{
    fflush(stdout);
    printf("error");
    return 1;
}
