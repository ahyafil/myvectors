% mixte de meansepare et meanblock
%meansepareblock(Y,X,n) calcule par blocks de n les moyennes de Y selon les
%valeurs (entières) de X

function [Ym Yste]=meansepareblock(Y,X,n,extrait)

X2=ceil([1:length(X)]/n); %vecteur qui code dans quel block on est

if nargin==4,
    Y=Y(:,extrait);
    X=X(:,extrait);
    X2=X2(:,extrait);
    X2 = X2 - min(X2) +1;
end



[Ym Yste]=meansepare2(Y,X,X2);

    