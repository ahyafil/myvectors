function varargout = separen(varargin)

warning('separen : use grpn instead');

varargout{1:nargout} = grpn(varargin{:});

% %A=separen(Y,tabX [,subset]) spare un tableau Y en plusieurs tableaux 
% %A{1,1,:,1} A{1,2} A{i1,i2,..in} etc...
% %correspondants aux valeurs 1 2 etc donns dans les vecteurs colonnes X1 ..
% %Xn du tableau d'entier d'entiers X
% %
% %(s'crit aussi directement separen(Y, [X1; X2; ...Xn])  )
% %
% %-separen({X1,X2...Xn}) renvoie dans chaque tableau les positions pour
% %chaque combi d'entiers, ie correspond ˆ separen(ones, {X1,X2...Xn})
% %
% % check that it works for the dimension parameter
% 
% function Matout=separen(Y, tabX, subset, dim)
% if nargin==1,
%     tabX=Y;
%     Y=[1:length(tabX(1,:))];
% end
% 
% if (nargin>=3)&& ~isempty(subset),  %ne garder qu'un subset
%     Y=Y(:,subset);
%     tabX=tabX(:,subset);
% end
% if nargin<4
%     dim = 2;
% else 
%     warning('parameter dim not yet coded');
% end  
% 
% [nbdim nby]=size(tabX); %nb de dim sur lequel on projette et nb d'lments du vecteur y
% maxn=max(tabX,[],2)';   %les max de chaque vecteur
% if nbdim==1, maxn =[maxn 1]; end
% 
% %step0 : remove all non positive values
% negval = any(tabX<=0);
% tabX(:, negval) = [];
% Y(negval) = [];
% 
% %step1 : transform all the different indices into a single index
% cellX = num2cell(tabX, 2)'; %transforme en cell de longueur ndim
% allX = sub2ind(maxn, cellX{:}); %
% 
% %step2 : get the corresponding values of Y separately for each of the value
% %of that new index
% Matout = cell(1, prod(maxn));
% Matout(1:max(allX)) = grp(Y, allX);
% 
% %step3 : give the output cell the required ndim shape
% %Matout = reshape(Matout, maxn,dim);
% Matout = reshape(Matout, maxn);