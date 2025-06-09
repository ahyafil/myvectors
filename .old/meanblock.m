%%%moyenne par n points un vecteurs (pour all�ger sa taille)
%%%syntaxe: meanblock(vecteur, n)
%%%si matrice, moyenne par d�faut dans la 2�me dim
%%%sinon, taper meanblock(vectuer, n,1)

function Y=meanblock(X,n, dim)
if nargin==2,
    dim=2;
end

siz = size(X);
l = size(X,dim);

perm = [1:ndims(X)];
perm(1) = dim;
perm(dim) = 1;

X = permute(X, perm);


nusiz = size(X);
nusiz(1) = floor(l/n);
Y = zeros(nusiz);

for i=1:floor(l/n)
    Y(i,:)=mean(X(n*i-n+1:n*i,:));
end

Y = permute(Y, perm);