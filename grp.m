%grp un tableau de valeurs en plusieurs tableaux A{1} A{2} etc...
%correspondants aux valeurs 1 2 etc donnés dans un deuxième tableau
%d'entiers
%arguments: tableau de valeurs, tableaux d'entiers
%
%-grp(tableau d'entiers) renvoie dans chaque tableau les positions pour
%chaque entier, ie correspond à grp(ones, tableau d'entiers)
%
%grp(Y,X, d) to compute over dimension d
%
%[Y1 Y2 ...] = grp(...) to assign the different vectors to different
%variables

function varargout = grp(Y, X, dim)

if nargin==1,
    X = Y;
    Y = 1:length(X);
end

if nargin <=2,
    if length(X) ~= size(Y,2)
        error('length of vector X and Y do not match');
    end
    Matout = cell(1,max(X));
    for i=1:max(X)
        Matout{i} = Y(:,X==i);
    end
else
    if length(X) ~= size(Y,dim)
        error('length of vector X and Y do not match');
    end
    Idx = cell(1,ndims(Y));  %create cell array for index of elments in Y
    for d=1:ndims(Y),
        Idx{d} = 1:size(Y,d);
    end
    Matout = cell(1,max(X));
    for i=1:max(X),
        Idx{dim} = X==i;  %change index in relevant dimension only
        Matout{i} = Y(Idx{:});
    end
end

if nargout <=1,
    varargout{1} = Matout;
else
    varargout = Matout;
end
