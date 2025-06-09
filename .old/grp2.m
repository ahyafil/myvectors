%sépare un tableau de valeurs en plusieurs tableaux A{1,1} A{1,2} A{i,j}etc...
%correspondants aux valeurs 1 2 etc donnés dans deux tableaux
%d'entiers X1 et X2
%arguments: tableau de valeurs, tableau1 d'entiers, tab2 d'entier
%
%-grp2(X1,X2) renvoie dans chaque tableau les positions pour
%chaque combi d'entiers, ie correspond à grp2(ones, X1,X2)
%
%grp(Y,X1, X2, d) to compute over dimension d(1) and d(2)
%
%[Y1 Y2 ...] = grp2(...) to assign the different vectors to different
%variables


function varargout = grp2(Y, X1, X2, dim)


if nargin==2,
    X2 = X1;
    X1 = Y;
    Y = 1:length(X1);
end


if nargin<4,
    dim = [2 2];
elseif length(dim)==1
    dim = [dim dim];
end

if length(X1) ~= size(Y,dim(1))
    error('length of vector X1 and Y do not match');
end
if length(X2) ~= size(Y,dim(2))
    error('length of vector X2 and Y do not match');
end

Idx = cell(1,ndims(Y));  %create cell array for index of elments in Y
for d=1:ndims(Y),
    Idx{d} = 1:size(Y,d);
end

C = cell(max(X1), max(X2));

for i=1:max(X1),
    for j=1:max(X2),
        if dim(1) == dim(2) %both in the same dimension,
            Idx{dim(1)} = X1==i & X2==j;  %change index in relevant dimension only
        else
            Idx{dim(1)} = X1==i;
            Idx{dim(2)} = X2==j;
        end
        C{i,j} = Y(Idx{:});
    end
end

if nargout <=1,
    varargout{1} = C;
else
    varargout = C;
end