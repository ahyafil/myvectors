function varargout = gmean(varargin)
%gmean(Y,X , options)
%computes the mean value of Y separately for each positive integer value taken by vector X
%
%gmean(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%gmean(..., 'max', n)
%gmean(..., 'std') or gmean(..., 'sem') or gmean(..., 'binosem')
%gmean(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%
% PLOTTING:
%gmean(...,'plot') to plot group averages (using wu).
%gmean(..., 'variables', {'var1' 'var2' ...}) to specify labels for
%variables
%
%See also GUN, GSUM, GCOUNT, GRPN, WU

%default values
errtype = '';

assert( nargin>=2, 'must provide at least two arguments'); 

%look in arguments ...
etypes = {'noerror', 'std', 'sem','ste', 'binoste'}; %... for error type
for t=1:length(etypes)
    isarg = cellfun(@(x) isequal(x,etypes{t}), varargin(3:end));
    if any(isarg)
        errtype = etypes{t};
        varargin(find(isarg)+2) = []; %remove this parameter from list of arguments
    end
end

%which function to apply
fun{1} = @(x) nan_mean(x,'dim');
plotfun = 1;

%err function
if isempty(errtype)
    errtype = 'std';
end
switch errtype
    case 'std'
        fun{2} = @(x) nan_std(x, 'dim');
        plotfun = [1 2];
    case {'ste','sem'}
        fun{2} = @(x) ste(x,'dim');
        plotfun = [1 2];
    case {'binoste','binosem'}
        fun{2} = @(x) sqrt(nan_mean(x, 'dim').*(1-nan_mean(x,'dim'))./sum(~isnan(x),'dim'));
        plotfun = [1 2];
end
multidim = repmat({'merge'}, 1, length(fun));  %if more than one dimensions : merge data along dimensions first (both for mean and std/Ste function)


%% apply the function to each group
varargout = cell(1,2+length(fun)); %number of output arguments from gfun
try
    [varargout{:}] = gfun(fun, varargin{1:2}, varargin{3:end}, 'multidim', multidim , 'plotfun', plotfun);
catch err
    if strcmp(err.identifier, 'gfun:unsupportedparameter')
        regstr = regexp(err.message, '\D+(\d+)', 'tokens');  %look for last number in error message (corresponding to index of unsupported argument in gfun)
        argnum = str2double(regstr{1})-3;                   %index of unsupported argument in grpmean
        error('grpmean:unsupportedparameter', 'unsupported parameter type for parameter #%d',argnum);
    else
        rethrow(err);
    end
end
    
varargout = varargout(1:nargout+(nargout==0));

end