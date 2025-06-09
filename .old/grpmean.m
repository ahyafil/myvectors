function [Ymean, Yerr, plothandle] = grpmean(Y, X, varargin)
%Ymean = grpmean(Y,X , options)
%computes the mean value of Y separately for each positive integer value taken by vector X
%
%grpmean(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%grpmean(..., 'max', n)
%[Ymean Ystd] = grpmean(..., 'std') or grpmean(..., 'ste')
%grpmean(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%
%grpmean(..., 'bar') to display results as bar plots
%grpmean(..., 'marge') to display results as marge plots
%[Ymean Yerr p] = grpmean(...) : p is the plothandles vector

%default values
%Ymean=[];
%Yerr=[];
errtype = 'std';
dim = 2;
maxvalue = [];
doplot = 0;
plottype = 'line';
errorstyle = 'bar';
subset = [];
permut = [];

%processing of parameters
if nargin >=3
    %subset
    if isnumeric(varargin{1}) || islogical(varargin{1})
        subset = varargin{1};
        v = 2;
    else
        v = 1;
    end
    
    %other parameters
    while v+2 <= nargin
        if ~ischar(varargin{v})
            error('unsupported parameter type for parameter #%d',v+3);
        end
        switch varargin{v}
            case 'max'
                v = v+1;
                maxvalue = varargin{v};
            case {'std', 'ste'}
                errtype = varargin{v};
            case {'dim', 'dimension'}
                v = v+1;
                dim = varargin{v};
            case {'plot'}
                doplot = 1;
            case {'line', 'bar'}
                plottype = varargin{v};
                doplot = 1;
            case {'marge', 'errorbars','errorline'}
                doplot = 1;
                errorstyle = varargin{v};
            case 'permute'
                v = v+1;
                permut = varargin{v};
            otherwise
                error('unknown parameter : ''%s''',varargin{v});
        end
        v = v+1;
    end
    
end

if nargout==2 && dim>2 && strcmp(errtype,'ste')
    error('cannot compute ste for dimension higher than 2');
end

%index for all values within Y
Idx = cell(1,ndims(Y));
for d=1:ndims(Y)
    Idx{d} = 1:size(Y,d);
end

%only use a subset of the data (if required)
if ~isempty(subset)
    X=X(subset);
    Idx{dim} = subset;
    Y=Y(Idx{:});
end

siz = size(Y);

%if no data
if isempty(X)
    if isempty(maxvalue)
        siz(dim) = 0;
    else
        siz(dim) = maxvalue;
    end
    Ymean = NaN(siz);
    Yerr = NaN(siz);
    return
end

warning('off','MATLAB:colon:logicalInput')

%get groups for X
[G, gnames] = grp2idx(X);
nG = length(gnames);

%get cell array with separate values
Z = grp(Y,G,dim);

%create output arguments
if isempty(maxvalue)
    maxvalue = nG;
    gpos = 1:nG;
else
    gpos = str2double(gnames);
    gnames = cellfun(@num2str, num2cell(1:maxvalue), 'UniformOutput', false);
    if max(gpos) > maxvalue
        error('maximum value in X larger than fixed largest value %d', maxvalue);
    end
end
siz(dim) = maxvalue;
Ymean = NaN(siz);
Yerr = NaN(siz);

%compute mean over each element of the cell array
for i=1:nG
    Idx{dim} = gpos(i);
    Ymean(Idx{:}) = nanmean(Z{i},dim);
    if nargout==2 || doplot
        if strcmp(errtype,'std')
            Yerr(Idx{:}) = nanstd(Z{i},0,dim);
        else
            Yerr(Idx{:}) = ste(Z{i},dim);
        end
    end
end

%plot
if doplot
    
    %levels
    if isvector(Ymean)
        levels = {gnames};
    else
        levels = repmat({{}}, 1, ndims(Ymean));
        levels{dim} = gnames;
    end
    
    %plot
    [~, ~, plothandle] = wu(Ymean, Yerr, levels, plottype, 'errorstyle', errorstyle, 'permute', permut);
    
end



