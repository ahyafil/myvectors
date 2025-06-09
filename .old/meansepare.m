function varargout = meansepare(varargin)

warning('meansepare : use grpmean instead');
varargout{1:nargout} = grpmean(varargin{:});

%function [Ymean, Yste] = meansepare(Y,X, subset, varargin)
% %meansepare(Y,X , options)
% %computes the mean value of Y separately for each positive integer value taken by vector X
% %
% %meansepare(Y, X, subset) allows to restrict the dataset to values in
% %vector subset (either a vector of position or a logical array)
% %
% %meansepare(..., 'max', n)
% %meansepare(..., 'std') or meansepare(..., 'ste')
% %meansepare(..., 'dim', d)  to work on a specific dimension of Y (by
% %default 2nd dimension, i.e. along lines)
% 
% 
% %default values
% Ymean=[];
% Yste=[];
% stdste = 'ste';
% dim = 2;
% maxvalue = [];
% 
% 
% %processing of parameters
% v = 1;
% while v+3<=nargin
%     if ~ischar(varargin{v})
%         error('unsupported parameter type for parameter #%d',v+3);
%     end
%     switch varargin{v}
%         case 'max'
%             v = v+1;
%             maxvalue = varargin{v};           
%         case {'std', 'ste'}
%             stdste = varargin{v};
%         case {'dim', 'dimension'}
%             v = v+1;
%             dim = varargin{v};
%         otherwise
%             error('unknown parameter #%d',v+3);
%     end
%     v = v+1;
% end
% 
% 
% if nargout==2 && dim>2 && strcmp(stdste,'ste')
%     error('cannot compute ste for dimension higher than 2');
% end
% 
% %index for all values within Y
% Idx = cell(1,ndims(Y));
% for d=1:ndims(Y)
%     Idx{d} = 1:size(Y,d);
% end
% 
% %only use an excerpt of the data (if required)
% if nargin>=3 && ~isempty(subset),
%     X=X(subset);
%     Idx{dim} = subset;
%     Y=Y(Idx{:});
% end
% 
% 
% siz = size(Y);
% 
% warning('off','MATLAB:colon:logicalInput')
% warning('off','MATLAB:divideByZero')
% 
% %get cell array with seperate values
% Z = separe(Y,X,dim);
% 
% %create output arguments
% if isempty(maxvalue),
%     maxvalue = max(X);
% end
% siz(dim) = maxvalue;
% Ymean = NaN(siz);
% Yste = NaN(siz);
% 
% 
% %compute mean over each element of the cell array
% for i=1:maxvalue
%     Idx{dim} = i;
%     Ymean(Idx{:}) = nanmean(Z{i},dim);
%     if nargout ==2,
%         if strcmp(stdste,'std')
%             Yste(Idx{:}) = nanstd(Z{i},0,dim);
%         else
%             Yste(Idx{:}) = ste(Z{i},dim);
%         end
%     end
% end
% 
% 
