function varargout = separe2(varargin)

warning('separe2 : use grp2 instead');

varargout{1:nargout} = grp2(varargin{:});

% %sépare un tableau de valeurs en plusieurs tableaux A{1,1} A{1,2} A{i,j}etc...
% %correspondants aux valeurs 1 2 etc donnés dans deux tableaux
% %d'entiers X1 et X2
% %arguments: tableau de valeurs, tableau1 d'entiers, tab2 d'entier
% %
% %-separe(X1,X2) renvoie dans chaque tableau les positions pour
% %chaque combi d'entiers, ie correspond à separe2(ones, X1,X2)
% %
% %separe(Y,X1, X2, d) to compute over dimension d(1) and d(2)
% %
% %[Y1 Y2 ...] = separe(...) to assign the different vectors to different
% %variables
% 
% % function Matout=separe2(Y, X1, X2, maxvalue)
% % if nargin==2,
% %     X2=X1;
% %     X1=Y;
% %     Y=[1:length(X1)];
% % end
% %
% % if size(Y,1)==size(Y,2), %2dim,
% %     siz = size(Y);
% %     X1 = repmat(X1, siz(1)/size(X1,1), siz(2)/size(X1,2));
% %     X2 = repmat(X2, siz(1)/size(X2,1), siz(2)/size(X2,2));
% %     Y = enligne(Y);
% %     X1 = enligne(X1);
% %     X2 = enligne(X2);
% % end
% %
% % Matout = {};
% %
% % if nargin ==4,
% %     Matout = cell(maxvalue(1), maxvalue(2));
% % end
% %
% % for i=1:max(X1)
% %     for j=1:max(X2)
% %            Matout{i,j}=Y(:,find((X1==i)&(X2==j)));
% % end
% % end
% 
% 
% 
% function varargout = separe2(Y, X1, X2, dim)
% 
% %Matout=[];
% 
% if nargin==2,
%     X2 = X1;
%     X1 = Y;
%     Y = 1:length(X1);
% end
% 
% %if nargin <=3,
% %    if length(X) ~= size(Y,2)
% %        error('length of vector X and Y do not match');
% %    end
% %    for i=1:max(X)
% %        Matout{i}=Y(:,X==i);
% %    end
% %else
% if nargin<4,
%     dim = [2 2];
% elseif length(dim)==1
%     dim = [dim dim];
% end
% 
% if length(X1) ~= size(Y,dim(1))
%     error('length of vector X1 and Y do not match');
% end
% if length(X2) ~= size(Y,dim(2))
%     error('length of vector X2 and Y do not match');
% end
% 
% Idx = cell(1,ndims(Y));  %create cell array for index of elments in Y
% for d=1:ndims(Y),
%     Idx{d} = 1:size(Y,d);
% end
% 
% Matout = cell(max(X1), max(X2));
% 
% for i=1:max(X1),
%     for j=1:max(X2),
%         if dim(1) == dim(2) %both in the same dimension,
%             Idx{dim(1)} = X1==i & X2==j;  %change index in relevant dimension only
%         else
%             Idx{dim(1)} = X1==i;
%             Idx{dim(2)} = X2==j;
%         end
%         Matout{i,j} = Y(Idx{:});
%     end
% end
% %end
% 
% if nargout <=1,
%     varargout{1} = Matout;
% else
%     varargout = Matout;
% end