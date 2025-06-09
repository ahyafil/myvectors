% mixte de meansepare2 et meanblock
%meansepareblock(Y,X1,X2, n) calcule par blocks de n les moyennes de Y selon les
%valeurs (entières) de X1 et X2

function [Ym Ystd]=meansepareblock(Y,X1, X2, n, extrait)

X3 = ceil([1:length(Y)]/n);

if nargin==5,
    Y=Y(:,extrait);
    X1=X1(:,extrait);
    X2=X2(:,extrait);
    X3 = X3(:,extrait);
    X3 = X3 - min(X3) +1;   %si l'extrait commence pas au 1er bloc, ne calcule pas pour les blocs sans données
end

[Ym Ystd] = meanseparen(Y, [X1 ; X2; X3]);
