%{
    #include <stdbool.h>

    int nbLines,nbConcert;
    //alloue espace nécessaire en supposant qu'un prenom/nom
    //soit plus petit que 128 caractères.
    char nom[128]; 

    //document valide ?
    bool isValid = true;
%}


maj 			[A-Z]
number 		[0-9]
nbPlaces 		[1-9]{number}?
motComp 		{maj}+"-"?{maj}+
prenomNom 		{motComp}"/"{motComp}
sautDeLigne 		\n
majOrNumber 		{maj}|{number}
nomConcert 		(({majOrNumber}+"-"?)?{majOrNumber}+)+
day 			([012]{number})|(3[01])
month 			(0?[1-9])|(1[012])
year 			{number}{2}
date 			{day}"/"{month}("/"{year})?
heure 			([01]{number})|(2[0-3])
minute 		[0-5]{number}
horaire 		{heure}":"{minute}
blancs 		[\t ]+
ligneDossier 		Dossier{blancs}{number}{8}{sautDeLigne}
ligneProprietaire 	{prenomNom}{sautDeLigne}
ligneConcert 		T{number}{2,6}{blancs}{nomConcert}{blancs}{date}{blancs}{horaire}{blancs}{nbPlaces}{blancs}places{sautDeLigne}


%%

{sautDeLigne}       	{ isValid = false; return 0;}
{ligneDossier}      	{
		                if(nbLines==0) //Doit être à la premiere ligne
		                {
		                    	nbLines++;
		                }
		                else
		                {
		                    	isValid = false;
		                    	fprintf(stderr,"ligneDossier doit être en première ligne\n");
		                    	return 0;
		                }
                    	}
                    
{ligneProprietaire} 	{
		                if(nbLines==1) //Doit être à la deuxième ligne
		                {
		                    	int len = yyleng;     //longueur de texte matché
		                    	int debut = 0;        // début du prenomNom
		                    	int fin = len-1;      //fin du prenomNom

		                    	for(int i = debut ; i < fin ; i++){ //boucle pour récuperer les valeurs
		                        	nom[i-debut] = yytext[i];
		                    	}
		                    	nbLines++;
		                }

		                else
		                {
		                    	isValid = false;
		                    	fprintf(stderr,"ligneProprietaire doit être en deuxième ligne\n");
		                    	return 0;
		                }
                    	}
                    
{ligneConcert}      	{
		                if(nbLines>=2) 
		                {
		                    	nbConcert++; 
		                	nbLines++; 
		                }
		                else
		                {
		                    	isValid = false;
		                    	fprintf(stderr,"ligneConcert au mauvaise endroit");
		                    	return 0;
		                }
                    	}
                    
.*                  	{
                        	isValid = false;
                        	fprintf(stderr,"Mot non reconnu : %s\n",yytext);
                        	return 0;
                    	}
                    
<<EOF>>           	{return 0;}

%%


int main(){
    yylex();
    if(isValid){
        printf("\n\n%s a acheté des places de %d concerts\n\n\n",nom,nbConcert);
    }
    else {
        fprintf(stderr,"\n\nErreur de saisie\n\n\n");
    }
    return 0;
}
