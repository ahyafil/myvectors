
function varargout = grpcat(d, C, G, varargin)
%grpcat(dim,C, G, options)
%concatenates cells in C along the dimension DIM according to groups G
%
%grpcat(dim,C, G, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%grpcat(..., 'max', n)
%grpcat(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%
%OUTPUT
%[D gnames gnames] = grpcat(...)
%D is the output cell array
%gnames : lables for the grouping values
%gnames2 : labels for the grouping values and indices along non-grouping
%dimensions

%!!!! does not work for more than one grouping vector !!!

%which function to apply
fun = @(x) catcell('d', x, 'dim');

%replace char 'd' by d
fstr = func2str(fun);
fstrrep = strrep(fstr, '''d''', num2str(d));
fun = str2func(fstrrep);

%apply the function to each group
varargout = cell(1,2); %number of output arguments from grpfun
[varargout{:}] = grpfun(fun, C, G, varargin{:}, 'multidim', 'merge');

varargout = varargout(1:max(1,nargout));