%%%somme par n points un vecteurs (pour alléger sa taille)
%%%syntaxe: sumblock(vecteur, n)
%%%si matrice, somme par défaut dans la 2ème dim
%%%sinon, taper sumblock(vecteur, n,1)

function Y=sumblock(X,n, dim)
if (nargin==3)&(dim==1), X=X'; end

[siz1 siz2]=size(X);
for i=1:floor(siz2/n)
    Y(:,i)=mean(X(:,n*i-n+1:n*i),2);
end
if (nargin==3)&(dim==1), Y=Y'; end