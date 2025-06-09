%%calcule les sommes d'en tableau en séparant 
%%les valeurs en fonction des valeurs de 2 tableaux d'entiers (utilise
%%la fonction separe2.m
%%calcule ces moyennes par bloc de n valeurs
%%sumsepare2block(Y,X1,X2,extrait)
%%on peut mettre un cinquième argument: restreindre l'analyse à un
%%sous-ensemble des données
%%
%%sumsepare(X1,X2,n) renvoie le nombre de fois où chaque combi d'entiers
%%apparait dans X1 X2, pour chaque bloc de n valeurs

function Ysum=sumsepare2block(Y,X1,X2,n,extrait)

if nargin==5,
    Y=Y(extrait);
    X1=X1(:,extrait);
    X2=X2(:,extrait);
end
if nargin==3,
    n=X2;
    X2=X1;
    X1=Y;
    Y=ones(1,length(X1));
end

for i=1:floor(length(X1)/n)
        Ysum(:,:,i)=sumsepare2(Y,X1,X2,i*n-n+1:i*n);
end
