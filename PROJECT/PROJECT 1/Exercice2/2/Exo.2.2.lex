%{
	#include <stdlib.h>
	#include "y.tab.h"
	void yyerror(char *);
%}	

maj 			[A-Z]
number 		[0-9]
motComp 		{maj}+"-"?{maj}+
prenomNom 		{motComp}"/"{motComp}
majOrNumber 		{maj}|{number}
nomConcert 		(({majOrNumber}+"-"?)?{majOrNumber}+)+
day 			([012]{number})|(3[01])
month 			(0?[1-9])|(1[012])
year 			{number}{2}
date 			{day}"/"{month}("/"{year})?
heure 			([01]{number})|(2[0-3])
minute 		[0-5]{number}
horaire 		{heure}":"{minute}
nb	 		[1-9]{number}?" "
blancs 		[\t ]+
	
%%

"Dossier"		{return dossier;}	
{number}{8}		{yylval.num = atoi(yytext); return NUM;}
{prenomNom}		{return nom;}
"T"{number}{2,6}	{return codeConcert;}
{nomConcert}		{return nomConcert;}
{date}			{return date;}
{horaire}		{return horaire;}
{nb}			{yylval.nb = atoi(yytext); return NB_PLACES;}
"places"		{return places;}
[\t ]+			;//on ignore les espaces
\n			{return EOL;}
.			{yyerror("invalid command");}

%%

int yywrap(void) {
	return 1;
}
