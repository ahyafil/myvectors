%%calcule les minimums d'en tableau en sŽparant 
%%les valeurs en fonction des valeurs d'un 2me tableau d'entier (utilise
%%la fonction separe.m
%%on peut mettre un troisime argument: restreindre l'analyse ˆ un
%%sous-ensemble des donnŽes
%%renvoie en troisime ŽlŽment la corrŽlation entre les 2sŽries de donnŽes
%%ainsi que la proba associŽe (fonction corrcoef)

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
