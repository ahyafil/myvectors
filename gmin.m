function varargout = gmin(Y, X, varargin)
%gmin(Y,X,...)
%computes the min value of Y separately for each positive integer value taken by vector X
%
%gmin(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%gmin(..., 'max', n)
%gmin(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%gmin(..., 'variables', {'var1' 'var2' ...}) to specify labels for
%variables
%
%[Ymin I] = gmin(...) to get the indices of minimal values in the
%original matrix
%
%See also MIN, GMAX, GRPN

nout = max(nargout,1); %either just min or min and indices

if nout<2  %get only min
    
    %which function to apply
    fun{1} = @(x) min(x,[],'dim');
    
    %apply the function to each group
    varargout = cell(1,3); %number of output arguments from grpfun
    [varargout{:}] = gfun(fun, Y, X, varargin{:}, 'multidim', 'recursive', 'nargout', 1);
    
else  %get indices
    %we got indices within submatrix, we need the real indices    
    
    %look for 'dim' option in options
    dim = [];
    v = 1;
    while v+2 <= nargin
        if isequal(varargin{v}, 'dim') || isequal(varargin{v}, 'dimension')
            v = v+1;
            dim = varargin{v};
        end
        v = v +1;
    end
    
    siz = size(Y);
    
    
    %what dimension to compute over
    if isempty(dim)
        if isvector(Y)
            dim = find(siz>1);  %non-singleton dimension
        else
            dim = 2;
        end
    end
    dim = unique(dim);
    assert(length(dim)<=1,'cannot compute indices for minimum over multiple dimensions');
    
    II = 1:siz(dim); %vector of indices
    
    %group indices
    IG = grpn(II,X);
    
    siz(dim) = 1;
    IG = repmat(IG, siz);
    
    %which function to apply
    fun{1} = @(x) min(x,[],dim);
    
    %apply the function to each group
    varargout = cell(1,4); %number of output arguments from grpfun
    [varargout{:}] = gfun(fun, Y, X, varargin{:}, 'multidim', 'recursive', 'nargout', 2, 'plotfun', 1);
       
    %retrieve global index of minimal values for each group
    varargout{2} = cellfun( @(M,x) M(x), IG, num2cell(varargout{2}));
end

varargout = varargout(1:nout);



