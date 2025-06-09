function varargout = gmax(Y, X, varargin)
%gmax(Y,X , options)
%computes the max value of Y separately for each positive integer value taken by vector X
%
%gmax(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%gmax(..., 'max', n)
%gmax(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%gmax(..., 'variables', {'var1' 'var2' ...}) to specify labels for
%variables
%
%[Ymax I] = gmax(...) to get the indices of maximal values in the
%original matrix


nout = max(nargout,1); %either just max or max and indices

if nout<2  %get only max

    %which function to apply
    fun{1} = @(x) max(x,[],'dim');

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

    %what dimension to compute over
    if isempty(dim)
        dim = 2;
    end
    dim = unique(dim);
    if length(dim)>1
        error('cannot compute indices for maximum over multiple dimensions');
    end

    II = 1:size(Y,dim); %vector of indices

    %group indices
    IG = grpn(II,X);

    %which function to apply
    fun{1} = @(x) max(x,[],dim);

    %apply the function to each group
    varargout = cell(1,4); %number of output arguments from grpfun
    [varargout{:}] = gfun(fun, Y, X, varargin{:}, 'multidim', 'recursive', 'nargout', 2, 'plotfun', 1);

    %retrieve global index of maximal values for each group
    varargout{2} = cellfun( @(M,x) M(x), IG, num2cell(varargout{2}));
end

varargout = varargout(1:nout);



