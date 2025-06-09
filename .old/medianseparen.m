%%[Ymean Yste]=medianseparen(Y,tabX,extrait)
%%calcule les medianes (et ste) d'en tableau en séparant 
%%les valeurs en fonction des valeurs de n tableaux d'entiers rentrés comme vecteurs colonnes de la matrice tabX (utilise
%%la fonction separen.m
%%on peut mettre un troisième argument: restreindre l'analyse à un
%%sous-ensemble des données
%%[Ymean Yste Xin]=meansepare(Y,tabX,extrait,1) présente les données autrement, en une
%%vecteur dont la première colonne vaut la moyenne pour la combinaison de
%%paramètres données sur la même ligne dans la matrice Xin


function [Ymean Yste Xini]=meanseparen(Y,tabX,extrait, autreprez)

if (nargin>=3)&&(length(extrait)),  %ne garder qu'un extrait
    Y=Y(:,extrait);
    tabX=tabX(:,extrait);
end
   
warning('off','MATLAB:colon:logicalInput')
warning('off','MATLAB:divideByZero')
Z=separen(Y,tabX);


Ymean = cellfun(@median, Z);
if nargout>2,
Yste = cellfun(@ste, Z);
end


% autrep=(nargin==4)&&autreprez;  %autre forme de présentation si 4ème arg==1
% 
% if (nargin>=3)&&(length(extrait)),  %ne garder qu'un extrait
%     Y=Y(:,extrait);
%     tabX=tabX(:,extrait);
% end
%    
% warning('off','MATLAB:colon:logicalInput')
% warning('off','MATLAB:divideByZero')
% [Z Xin]=separen(Y,tabX);
% 
% maxn=max(tabX,[],2)';   %nb de valeurs pour chaq vecteur
% 
% 
% 
% for i=1:prod(maxn)   %on fait tous les indices i1,i2...in avec un seul 
%     warning('off','MATLAB:colon:logicalInput')
%     warning('off','MATLAB:divideByZero')
%     Ymean(i)=median(Z{i});
%     Yste(i)=ste(Z{i}');
%     if length(Xin{i}), Xini(i,:)=Xin{i}; end
%     end
% 
% if ~autrep  %présentation normale
% Ymean=reshape(Ymean,maxn);  %on remet le vecteur obtenu sous forme d'une matrice à n dim
% Yste=reshape(Yste,maxn);
% end