%%calcule les sommes d'en tableau en sŽparant 
%%les valeurs en fonction des valeurs de 2 tableaux d'entiers (utilise
%%la fonction separe2.m
%%on peut mettre un quatrime argument: restreindre l'analyse ˆ un
%%sous-ensemble des donnŽes
%%
%%sumsepare(X1,X2) renvoie le nombre de fois o chaque combi d'entiers
%%apparait dans X1 X2

function Ysum=sumsepare2(Y,X1,X2,extrait, maxvalue)

if nargin>=4,
    Y=Y(extrait);
    X1=X1(:,extrait);
    X2=X2(:,extrait);
end
if nargin==2,
    X2=X1;
    X1=Y;
    Y=ones(1,length(X1));
end

Z = grp2(Y,X1,X2);


if nargin==5,
    Ysum = zeros(  maxvalue(1), maxvalue(2));
end

for i=1:max(X1)
    for j=1:max(X2)
    Ysum(i,j) = sum(Z{i,j},2);
        end
end
