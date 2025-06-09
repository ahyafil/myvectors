%%mixte de sumsepare et meanblock
%% sumsepareblock(Y,X,n) renvoie par block de n valeurs la moyenne des
%% valeurs prises par X pour chaque valeur entière prise par X
%% 
%%on peut mettre un qautrième argument: restreindre l'analyse à un
%%sous-ensemble des données
%%
%%sumsepare(X,n) renvoie le nbre de fois où chaque entier est présent dans
%%X pour chaque bloc de n valeurs


function Ysum=sumsepareblock(Y,X, n,extrait)
if nargin==4,
    Y=Y(:,extrait);
    X=X(:,extrait);
end
if nargin==2,
    n=X;
    X=Y;
    Y=ones(1,length(X));
end


for i=1:floor(length(X)/n)
        Ysum(:,i)=sumsepare(Y,X,i*n-n+1:i*n);
end