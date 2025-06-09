
function [Ymean, Yste] = grpmean2(Y,X1, X2, subset, varargin)
%grpmean2(Y,X , options)
%computes the mean value of Y separately for each positive integer value taken by vector X
%
%grpmean2(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%grpmean2(..., 'max', n)
%grpmean2(..., 'std') or grpmean2(..., 'ste')
%grpmean2(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)


%default values
%Ymean=[];
%Yste=[];
stdste = 'ste';
dim = [2 2];
maxvalue = [];


%processing of parameters
v = 1;
while v+4<=nargin
    if ~ischar(varargin{v})
        error('unsupported parameter type for parameter #%d',v+3);
    end
    switch varargin{v}
        case 'max'
            v = v+1;
            maxvalue = varargin{v};
        case {'std', 'ste'}
            stdste = varargin{v};
        case {'dim', 'dimension'}
            v = v+1;
            dim = varargin{v};
        otherwise
            error('unknown parameter #%d',v+3);
    end
    v = v+1;
end

if nargout==2 && max(dim)>2 && strcmp(stdste,'ste')
    error('cannot compute ste for dimension higher than 2');
end

%index for all values within Y
Idx = cell(1,ndims(Y));
for d=1:ndims(Y)
    Idx{d} = 1:size(Y,d);
end

%only use an excerpt of the data (if required)
if nargin>=4 && ~isempty(subset),
    X1 = X1(subset);
    X2 = X2(subset);
    Idx{dim(1)} = subset;
    Y=Y(Idx{:});
end

if length(dim) ==1,
    dim = [dim dim];
end


warning('off','MATLAB:colon:logicalInput')

%get cell array with seperate values
Z = grp2(Y, X1, X2, dim);

%create output arguments
if isempty(maxvalue) || isnan(maxvalue(1)),
    maxvalue(1) = max(X1);
end
if length(maxvalue)<2 || isnan(maxvalue(2)),
    maxvalue(2) = max(X2);
end

%allocate output matrices size
siz = size(Y);
if dim(1)==dim(2),
    siz(dim(1)) = prod(maxvalue);
else
    siz(dim(1)) = maxvalue(1);
    siz(dim(2)) = maxvalue(2);
end

Ymean = NaN(siz);
Yste = NaN(siz);

%compute mean over each element of the cell array
if dim(1)==dim(2),  %over same dimension
    for i=1:maxvalue(1)
        for j = 1:maxvalue(2)
            Idx{dim(1)} = sub2ind(maxvalue, i, j);
            Ymean(Idx{:}) = nanmean(Z{i,j},dim(1));
            if nargout ==2,
                if strcmp(stdste,'std')
                    Yste(Idx{:}) = nanstd(Z{i,j},0,dim(1));
                else
                    Yste(Idx{:}) = ste(Z{i,j},dim(1));
                end
            end
        end
    end
    
    %reshape so that X1 and X2 are over different dimensions
    if isvector(Ymean),  % either a simple matrix if no other dimension
        Ymean = reshape(Ymean, maxvalue);
        if nargout ==2,
           Yste = reshape(Yste, maxvalue); 
        end
    else                 %otherwise, X1 stays at same dimension, X2 used as another dimension
        siz = [siz(1:dim(1)-1) maxvalue siz(dim(1)+1:end)];
        Ymean = reshape(Ymean, siz); %first split dimension into two : one for X1 and one for X2
        
        permorder = 1:ndims(Ymean);
        permorder(dim(1)+1) = length(permorder);
        permorder(end) = dim(1)+1;
        Ymean = permute(Ymean, permorder); %then permute to set X2 at last dimension
        
        if nargout==2,
           Yste = reshape(Yste, siz);
           Yste = permute(Yste, permorder);
        end
        
    end
        
    
    
else  %over different dimensions
    for i=1:maxvalue(1)
        for j = 1:maxvalue(2)
            Idx{dim(1)} = i;
            Idx{dim(2)} = j;
            mean1 = nanmean(Z{i,j},dim(1));
            Ymean(Idx{:}) = nanmean(mean1, dim(2));
            if nargout ==2,
                if strcmp(stdste,'std')
                    ste1 = nanstd(Z{i,j}, dim(1));
                    Yste(Idx{:}) = nanstd(ste1,0,dim(2));
                else
                    ste1 = ste(Z{i,j}, dim(1));
                    Yste(Idx{:}) = ste(ste1,dim(2));
                end
            end
        end
    end
    
end


