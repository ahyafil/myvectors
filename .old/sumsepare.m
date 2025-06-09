%%calcule les sommes d'en tableau en s�parant 
%%les valeurs en fonction des valeurs d'un 2�me tableau d'entier (utilise
%%la fonction separe.m
%%on peut mettre un troisi�me argument: restreindre l'analyse � un
%%sous-ensemble des donn�es
%%
%%sumsepare(X) renvoie le nbre de fois o� chaque entier est pr�sent dans X


function Ysum=sumsepare(varargin)

if varargin{nargin}=='p',   %veut doplotr
doplot=1;
nbarg=nargin-1;
else
    doplot=0;
    nbarg=nargin;
end

if nbarg==1,
    X=varargin{1};
    Y=ones(1,length(X));
else
    X=varargin{2};
    Y=varargin{1};
end

if nbarg==3,   %extrait
    Y=Y(:,varargin{3});
    X=X(:,varargin{3});
end


Z = grp(Y,X);
Ysum = cellfun(@(x) sum(x,2), Z);
%Ysum=zeros(1,max(max(X,0)));
%for i=1:max(X)
%    Ysum(:,i)=sum(Z{i},2);
%end
   
if doplot,
    bar(Ysum);
end