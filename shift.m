%shift(x,n, [,memetaille] [,defvalue] )
%rajoute n zeros avant le vecteur (ou tableau) x si n>0
%enlve les -n premiers lments si n<0
%memetaille: booleen, si le nouveau vecteur a la mme taille que x quitte ˆ
%supprimer valeur (par dfaut 1)
%defvalue: valeur mise pour lments rajouts au dbut ou ˆ la fin (par
%dfaut 0)
%shift(x) fait comme shift(x,1)

%add dim


function u=shift(x,n,memetaille, defvalue)
[a b]=size(x);
if nargin<2, n=1; end
if nargin<3, memetaille=1; end
if nargin<4,
    switch class(x),
        case 'char',
            defvalue = ' ';
        case {'double', 'single', 'int8'},
            defvalue = 0;
        case 'nominal',
            defvalue = nominal(nan);
        case 'ordinal',
            defvalue = ordinal(nan);
        case 'logical',
            defvalue = false;
        otherwise
            error('unsupported data type');
            
    end
%     if ischar(x),
%         defvalue = ' ';
%     else
%         defvalue=0;
%     end
end

if n>0 %on rajoute n 0 avant
    u=[repmat(defvalue,a,n)  x];
    if memetaille, u=u(1:a, 1:b); end   %coupe les dernires valeurs
else  %on enlve les -n premiers lments
    u=x(:,-n+1:b);
    if memetaille, u(1:a,b+n+1:b) = repmat(defvalue,a,-n); end   %complte avec des valeurs par dfaut
end
