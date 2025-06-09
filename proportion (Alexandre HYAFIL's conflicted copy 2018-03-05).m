function prop = proportion(X,Y)

X=double(X);
X = X(:)';


if nargin==1,

    prop(2,:) = unique_onenan(X);    
    prop(1,:) = grpcount(X);
else
    Y=double(Y);
    Y = Y(:)';
    varargout{2} = unique_onenan(X);
    varargout{3} = unique_onenan(Y);
  prop = grpcount({X, Y}); 
end
end

function [Xval, nanval] = unique_onenan(X)
    nanval = isnan(X);
    Xval = unique(X(~nanval));
    if any(nanval),
        Xval(end+1) = nan;
    end
end