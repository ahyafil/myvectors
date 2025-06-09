function varargout = gsum(varargin)
%S = gsum(Y,G , options)
%computes the sum of elements in Y separately for each positive integer value taken by grouping variable G
%
%gsum(Y, G, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%gsum(..., 'max', n)
%gsum(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%
%gsum(..., 'nansum') to use ignore nan values in sum
%
%OUTPUT
%[S gnames gnames] = gsum(...)
%gnames : lables for the grouping values
%gnames2 : labels for the grouping values and indices along non-grouping
%dimensions
%
%See also GMEAN, GFUN, GRPN, GCOUNT, NANSUM

%which function to apply
isnansum = cellfun(@(x) isequal(x, 'nansum'), varargin);
if any(isnansum)
    fun = @(x) nansum(x,'dim');
    varargin(isnansum) = [];
    
else
    fun = @(x) sum(x,'dim');
end

%apply the function to each group
varargout = cell(1,2); %number of output arguments from gfun
[varargout{:}] = gfun(fun, varargin{:}, 'multidim', 'merge');

%output arguments
varargout = varargout(1:nargout+(nargout==0));