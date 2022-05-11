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
nbPlaces 		[1-9]{number}?" places" 
blancs 		[\t ]+
	
%%

"Dossier"		{return dossier;}	
{number}{8}		{return number;}
{prenomNom}		{return nom;}
"T"{number}{2,6}	{return codeConcert;}
{nomConcert}		{return nomConcert;}
{date}			{return date;}
{horaire}		{return horaire;}
{nbPlaces}		{return nbPlaces;}
[\t ]+			;//on ignore les espaces
\n			{return EOL;}
.			{yyerror("invalid character");}

%%

int yywrap(void) {
	return 1;
}
