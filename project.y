%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int expn_type = -1;
	int temp;
	int idx = 0;
	int table_idx = 0;
	struct symbol_table{char var_name[30]; int type;} sym[20];
	extern int lookup_in_table(char var[30]);
	extern void insert_to_table(char var[30], int type);
	char var_list[20][30];	//20 variable names with each variable being atmost 50 characters long
	extern int *yytext;
%}
%union{
int data_type;
char var_name[30];
}

%token NUMBER PROC MAIN BGIN COLON END ASSIGNMENT VAR_START COMA SEMICOLON VAR

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE

%type<data_type>TYPE
%type<var_name>VAR

%start prm
%%

prm:	 			PROC MAIN BGIN COLON{
						printf("#include<stdio.h>\nint main()\n{\n");
					}
					STATEMENTS END COLON{
						printf("}\n");
					}

STATEMENTS: 		STATEMENTS {printf("\t");} STATEMENT
					| ;

STATEMENT: 			VAR_START VAR_LIST COLON TYPE SEMICOLON {
						if(current_data_type == 0)
							printf("int ");
						else if(current_data_type == 1)
							printf("char ");
						else if(current_data_type == 2)
							printf("float ");
						else if(current_data_type == 3)
							printf("double ");
						for(int i = 0; i < idx - 1; i++){	
							printf("%s,", var_list[i]);
						}
						printf("%s;\n", var_list[idx - 1]);
						idx = 0;
					}
					| VAR {
							printf("%s", yylval.var_name);
							if((temp=lookup_in_table(yylval.var_name))!=-1) {
								if(expn_type==-1)
									expn_type=temp;
								else if(expn_type!=temp) {
									printf("\n type mismatch in the expression\n");
									yyerror("");
									exit(0);
								}
							}
							else {
								printf("\n variable \" %s\" undeclared\n", yylval.var_name);
								yyerror("");
								exit(0);
							}
							expn_type=-1;
					} 
					ASSIGNMENT {printf("=");} A_EXPN SEMICOLON {
						printf(";\n");
					}
A_EXPN : 			VAR {
						if((temp=lookup_in_table($1))!=-1) {
							if(expn_type==-1) {
								printf("%s", yylval.var_name);
								expn_type=temp;
							}
							else if(expn_type!=temp) {
								printf("\ntype mismatch in the expression\n");
								yyerror("");
								exit(0);
							}
						}
						else {
							printf("\n variable \"%s\" undeclared\n",$1);
							yyerror("");
							exit(0);
						}	
		 			}
					| NUMBER {printf("%s", yylval.var_name);}

VAR_LIST: 			VAR {
						insert_to_table($1, current_data_type);
						strcpy(var_list[idx], $1); 
						idx++;
					} COMA VAR_LIST
					| VAR {
						insert_to_table($1, current_data_type);
						strcpy(var_list[idx], $1); 
						idx++;
					}


TYPE : 				INT {
						$$=$1;
						current_data_type=$1;
					}
					| CHAR  {
						$$=$1;
						current_data_type=$1;
					}
					| FLOAT {
						$$=$1;
						current_data_type=$1;
					}
					| DOUBLE {
						$$=$1;
						current_data_type=$1;
					}

%%

int lookup_in_table(char var[30])
{
	for(int i=0; i<table_idx; i++)
	{
		if(strcmp(sym[i].var_name, var)==0)
			return sym[i].type;
	}
	return -1;
}

void insert_to_table(char var[30], int type)
{
	if(lookup_in_table(var)==-1)
	{
		strcpy(sym[table_idx].var_name,var);
		sym[table_idx].type = type;
		table_idx++;
	}
	else {
		printf("Multiple declaration of variable\n");
		yyerror("");
		exit(0);
	}
}

int main() {
	yyparse();
	return 0;
}

int yyerror(const char *msg) {
	extern int yylineno;
	printf("Parsing failed\nLine number: %d %s\n", yylineno, msg);
	success = 0;
	return 0;
}
