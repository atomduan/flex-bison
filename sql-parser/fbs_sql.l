%option nounput noinput noyywrap

%{
#include <fbs_sql_parser.h>
#include <fbs_yy_gen.h>
/**
 * From bison doc:
 * The lexical analyzer’s job is low-level parsing: converting characters or sequences of char- acters into tokens.
 * This works in two ways. 
 * If the token type is a character literal, 
 * then its numeric code is that of the character; 
 * you can use the same character literal in the lexical analyzer to express the number. 
 * If the token type is an identifier, 
 * that identifier is defined by Bison as a C macro 
 * whose definition is the appropriate number. 
 * In this example, therefore, NUM becomes a macro for yylex to use.
 */
#define YY_DECL int yylex(YYSTYPE *lvalp, YYLTYPE *llocp)
%}

ANY_OTHER       .|\n

%%
{ANY_OTHER}     {   return (int)*yytext;    }
%%
