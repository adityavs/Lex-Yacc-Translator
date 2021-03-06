%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
%}
%%

"*"(.|\n)*"*"						{strcpy(yylval.var_name, yytext);return COMMENT;}
"Procedure"							{return PROC;}
"Main()"							{return MAIN;}
"Begin"								{return BGIN;}
":"									{return COLON;}
"End"								{return END;}
"var"								{return VAR_START;}
"int"								{yylval.data_type=0; return INT;}
"char"								{yylval.data_type=1; return CHAR;}
"float"								{yylval.data_type=2; return FLOAT;}
"double"							{yylval.data_type=3; return DOUBLE;}
"Read"								{return READ;}
"Write"								{return WRITE;}
"ElseIf"							{return ELSEIF;}
"If"								{return IF;}
"Else"								{return ELSE;}
"EndIf"								{return ENDIF;}
"goto"								{return GOTO;}
"For"								{return FOR;}
"To"								{return TO;}
"Do"								{return DO;}
"EndFor"							{return ENDFOR;}
"Repeat"							{return REPEAT;}
"Until"								{return UNTIL;}
"While"								{return WHILE;}
"EndWhile"							{return ENDWHILE;}
"<-"								{return ARROW_ASSIGNMENT;}
"("									{return LB;}
")"									{return RB;}
";"									{return SEMICOLON;}
","									{return COMA;}
":="								{return ASSIGNMENT;}
"And"								{return LAND;}
"Or"								{return LOR;}
">="								{return GEQ;}
"<="								{return LEQ;}
">"									{return GT;}
"<"									{return LT;}
"!="								{return NEQ;}
"=="								{return DEQ;}
"+"									{return PLUS;}
"-"									{return MINUS;}
"*"									{return MUL;}
"/"									{return DIV;}
"%"									{return MOD;}
"Not"									{return NOT;}
'[^'"]*'							{strcpy(yylval.var_name, yytext);
									 return QUOTED_STRING;}
[a-zA-Z]+							{strcpy(yylval.var_name, yytext);
									 return VAR;}
[0-9]+ 								{strcpy(yylval.var_name, yytext);
									 return NUMBER;}
[\n\t ]+							{/* ignoring newlines, tabs and spaces */}
%%

int yywrap(void) {
	return 1;
}

