function varargout = separe(varargin)

warning('separe : use grp instead');

varargout{1:nargout} = grp(varargin{:});

% %spare un tableau de valeurs en plusieurs tableaux A{1} A{2} etc...
% %correspondants aux valeurs 1 2 etc donns dans un deuxime tableau
% %d'entiers
% %arguments: tableau de valeurs, tableaux d'entiers
% %
% %-separe(tableau d'entiers) renvoie dans chaque tableau les positions pour
% %chaque entier, ie correspond ˆ separe(ones, tableau d'entiers)
% %
% %separe(Y,X, d) to compute over dimension d
% %
% %[Y1 Y2 ...] = separe(...) to assign the different vectors to different
% %variables
% 
% function varargout = separe(Y, X, dim)
% 
% Matout=[];
% 
% if nargin==1,
%     X = Y;
%     Y = 1:length(X);
% end
% 
% if nargin <=2,
%     if length(X) ~= size(Y,2)
%         error('length of vector X and Y do not match');
%     end
%     for i=1:max(X)
%         Matout{i}=Y(:,X==i);
%     end
% else
%     if length(X) ~= size(Y,dim)
%         error('length of vector X and Y do not match');
%     end
%     Idx = cell(1,ndims(Y));  %create cell array for index of elments in Y
%     for d=1:ndims(Y),
%         Idx{d} = 1:size(Y,d);
%     end
%     for i=1:max(X),
%         Idx{dim} = X==i;  %change index in relevant dimension only
%         Matout{i} = Y(Idx{:});
%     end   
% end
% 
% if nargout <=1,
%    varargout{1} = Matout;
% else
%    varargout = Matout; 
% end
