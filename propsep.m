%%[Ymean Yste]=propsep(Y, tabX [,extrait])
%%calcule les proportion (et ste) d'en tableau en s�parant 
%%les valeurs en fonction des valeurs de n tableaux d'entiers rentr�s comme vecteurs colonnes de la matrice tabX (utilise
%%la fonction separen.m
%%on peut mettre un troisi�me argument: restreindre l'analyse � un
%%sous-ensemble des donn�es



function [Ymean ]=propsep(Y,tabX,extrait, resiz)

if (nargin>=3)&&(length(extrait)),  %ne garder qu'un extrait
    Y=Y(:,extrait);
    tabX=tabX(:,extrait);
end
   
warning('off','MATLAB:colon:logicalInput')
warning('off','MATLAB:divideByZero')

sumY = sumseparen([Y;tabX]);

ssY = sum(sumY);
ssY = repmat(ssY, size(sumY,1),1);
Ymean = sumY./ssY;

if nargin ==4,
    Ymean = resize(Ymean, resiz);
end
    


