%{
int nbCounts;
int validClosures;
%}
%option caseless

entier [0-9]+
relatif [-+]?{entier}
flottant {relatif}.{entier}(e{relatif})?
chaine (\"[^"]\")+
commentaire --.*
pv (;)
ignore [\t ]

%%
{flottant}              {nbCounts++; printf("Flottant");}
{entier}                {nbCounts++; printf("Entier");}
{chaine}                {printf("Chaine");}
{commentaire}           {printf("");}
\n+                     {printf("");}
{pv}                    {printf(";\n");}
nom                     {printf("Nom");}
debut                   {validClosures++; printf("Debut");}
fin                     {validClosures--; printf("Fin");}
avance                  {printf("Avance");}
tourner                 {printf("Tourner");}
fois                    {printf("Fois");}
affiche                 {printf("Affiche");}
{ignore}+               {printf(" ");}

%%
int main()
{
    nbCounts = 0;
    validClosures = 0;
    yylex();
    printf("Il y a %i nombres (entiers ou flottants) \n", nbCounts);
    
    if(validClosures == 0)
    {
        printf("Il y a autant de 'debut' que de 'fin' => OK\n");
    }

    else
    {
        printf("Il n'y a pas autant de 'debut' que de 'fin' => ERROR\n");
    }
}
