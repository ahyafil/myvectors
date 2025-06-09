function varargout = gmedian(varargin)
%gmedian(Y,X,...)
%computes the median value of Y separately for each positive integer value taken by vector X
%
%gmedian(Y, X, subset) allows to restrict the dataset to values in
%vector subset (either a vector of position or a logical array)
%
%gmedian(..., 'max', n)
%gmedian(..., 'std') or grpmedian(..., 'ste')
%gmedian(..., 'dim', d)  to work on a specific dimension of Y (by
%default 2nd dimension, i.e. along lines)
%gmedian(..., 'variables', {'var1' 'var2' ...}) to specify labels for
%variables
%
%See also GMEAN, GFUN, GSUM, GCOUNT, GRPN

%default values
errtype = '';


%look in arguments ...
etypes = {'noerror', 'std', 'ste'}; %... for error type
for t=1:length(etypes)
    isarg = cellfun(@(x) isequal(x,etypes{t}), varargin(3:end));
    if any(isarg)
        errtype = etypes{t};
        varargin(find(isarg)+2) = []; %remove this parameter from list of arguments
    end
end

%which function to apply
fun{1} = @(x) nanmedian(x,'dim');
plotfun = 1;

%err function
if isempty(errtype)
    errtype = 'std';
end
switch errtype
    case 'std'
        fun{2} = @(x) nanstd(x,0, 'dim');
        plotfun = [1 2];
    case 'ste'
        fun{2} = @(x) ste(x,'dim');
        plotfun = [1 2];
end
multidim = repmat({'merge'}, 1, length(fun));  %if more than one dimensions : merge data along dimensions first (both for median and std/Ste function)

%% apply the function to each group
varargout = cell(1,2+length(fun)); %number of output arguments from grpfun
try
    [varargout{:}] = gfun(fun, varargin{1:2}, varargin{3:end}, 'multidim', multidim , 'plotfun', plotfun);
catch err
    if strcmp(err.identifier, 'grpfun:unsupportedparameter')
        regstr = regexp(err.message, '\D+(\d+)', 'tokens');  %look for last number in error message (corresponding to index of unsupported argument in grpfun)
        argnum = str2double(regstr{1})-3;                   %index of unsupported argument in grpmedian
        error('grpmedian:unsupportedparameter', 'unsupported parameter type for parameter #%d',argnum);
    else
        rethrow(err);
    end
end
    
varargout = varargout(1:nargout+(nargout==0));



