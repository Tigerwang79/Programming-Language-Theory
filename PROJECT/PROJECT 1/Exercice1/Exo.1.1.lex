%{
	int nbLines;
	int nbConcert;
%}


maj 				[A-Z]
number 			[0-9]
nbPlaces 			[1-9]{number}?
motComp 			{maj}+"-"?{maj}+
prenomNom 			{motComp}"/"{motComp}
sautDeLigne 			\n
majOrNumber 			{maj}|{number}
nomConcert 			(({majOrNumber}+"-"?)?{majOrNumber}+)+
day 				([012]{number})|(3[01])
month 				(0?[1-9])|(1[012])
year 				{number}{2}
date 				{day}"/"{month}("/"{year})?
heure 				([01]{number})|(2[0-3])
minute 			[0-5]{number}
horaire 			{heure}":"{minute}
blancs 			[\t ]+
ligneDossier 			Dossier{blancs}{number}{8}{sautDeLigne}
ligneProprietaire 		{prenomNom}{sautDeLigne}
ligneConcert 			T{number}{2,6}{blancs}+{nomConcert}{blancs}+{date}{blancs}+{horaire}{blancs}+{nbPlaces}{blancs}+places{sautDeLigne}


%%

{sautDeLigne}       		{
                        		fprintf(stderr,"saut de ligne inutile interdit\n");
                        		return 0;
                    		}
                    		
{ligneDossier}      		{
                        		if(nbLines==0)
                        		{
                            			printf("\n\ndossier codeDosier RC\n");
                            			nbLines++;
                        		}
                        		else
                        		{
                            			fprintf(stderr,"ligneDossier doit être en première ligne\n");
                            			return 0;
                        		}	
                    		}
                    		
{ligneProprietaire} 		{
                        		if(nbLines==1)
                        		{
                            			printf("prenomNom RC\n");
                            			nbLines++;
                        		}
                        		else
                        		{
                            			fprintf(stderr,"ligneProprietaire doit être en deuxième ligne\n");
                            			return 0;
                        		}
                    		}
                    		
{ligneConcert}      		{
                        		if(nbLines>=2) 
                        		{
                            			printf("codeConcert nomConcert date heure nb places RC\n");
                            			nbLines++;
                        		}
                        		else
                        		{
				            fprintf(stderr,"les ligneConcert doivent être à partir de la troisième ligne\n");
				            return 0;
                        		}
                    		}
                    		
.*                  		{
		                    fprintf(stderr,"Mot non reconnu : %s\n",yytext);
		                    return 0;
                    		}
                    		
<<EOF>>				{printf("FinFichier\n"); return 0;}

%%
