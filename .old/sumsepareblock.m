%%mixte de sumsepare et meanblock
%% sumsepareblock(Y,X,n) renvoie par block de n valeurs la moyenne des
%% valeurs prises par X pour chaque valeur enti�re prise par X
%% 
%%on peut mettre un qautri�me argument: restreindre l'analyse � un
%%sous-ensemble des donn�es
%%
%%sumsepare(X,n) renvoie le nbre de fois o� chaque entier est pr�sent dans
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