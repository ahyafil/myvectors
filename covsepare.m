%%calcule les covariances de 2 vecteurs Y1 et Y2 s�par�ment pour chaque valeur 
%%prise par un tableau X :
%%covsepare(Y1, Y2, X, extrait)
%%
%%on peut mettre un quatri�me argument: restreindre l'analyse � un
%%sous-ensemble des donn�es

function Ycov=covsepare(Y1, Y2, X, extrait)
if nargin==4,
    Y1=Y1(:,extrait);
    Y2=Y2(:,extrait);
    X=X(:,extrait);
end
warning('off','MATLAB:colon:logicalInput')
warning('off','MATLAB:divideByZero')
Z1=separe(Y1,X);
Z2=separe(Y2,X);
for i=1:max(X)
    Ycov(:,:,i)=cov(Z1{i},Z2{i});
    end