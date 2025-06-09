function prop = proportion(X,Y)
% first row: value counts
% second row: values

if ~isstring(X) && ~iscell(X)
X=double(X);
end
X = X(:)';


if nargin==1

    prop(2,:) = unique_onenan(X);  
    if ~isstring(X) && ~iscell(X)
    prop(:,isnan(prop(2,:))) = [];
    end
    prop(1,:) = gcount(X);
else
    Y=double(Y);
    Y = Y(:)';
    varargout{2} = unique_onenan(X);
    varargout{3} = unique_onenan(Y);
  prop = gcount({X, Y}); 
end
end

function [Xval, nanval] = unique_onenan(X)
if iscell(X) || isstring(X)
    nanval = false(size(X));
else
    nanval = isnan(X);
end
    Xval = unique(X(~nanval));
    if any(nanval)
        Xval(end+1) = nan;
    end
end