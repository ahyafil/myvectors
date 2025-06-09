%%calcule les minimums d'en tableau en s�parant 
%%les valeurs en fonction des valeurs d'un 2�me tableau d'entier (utilise
%%la fonction separe.m
%%on peut mettre un troisi�me argument: restreindre l'analyse � un
%%sous-ensemble des donn�es
%%renvoie en troisi�me �l�ment la corr�lation entre les 2s�ries de donn�es
%%ainsi que la proba associ�e (fonction corrcoef)

function Ymin=minsepare(Y,X, extrait, maxvalue)
if nargin>=3 & length(extrait),
    Y=Y(:,extrait);
    X=X(:,extrait);
end


Ymin=[];


if nargin==4,
    if isstr(maxvalue) & streq(maxvalue, 'all')
        X=replace(X);
    else
    Ymin=NaN( size(Y,1), maxvalue);
    end
end


Z=separe(Y,X);
for i=1:max(X)
    if length(Z{i}),
    Ymin(:,i)=min(Z{i});
    else Ymin(:,i)=NaN;
    end
end
