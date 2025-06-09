function varargout = ghist(X, G, binz, subset, varargin)
%[N, H, plothandle] = ghist(X, G  [,bins] [,subset] )
% bins is either a scalar defining the number of bins or the bin boundaries
%
%ghist(..., 'norm') to normalize all histograms by number of elements in
%each group
%ghist(...., 'plot', plotoptions) to plot : type 'help wu' for help for
%plotting options
%
%subset : 'all' to include all data points
%
%See also GCOUNT, GRPN, GMEAN, HIST

%does not deal with 'dim' argument

doplot = (nargout==0);
if nargin<3 || isempty(binz)
    binz = 10;   %default number of bins
end

if (nargin >=4) && ~isempty(subset)
    X = X(:,subset);
    if iscell(G)
        for i=1:numel(G)
            G{i} = G{i}(:,subset);
        end
    else
    G = G(:,subset);
    end
end
if ~iscell(G)
    G = { G };
end

%group values
[C, labels] = grpn(X, G);

%option parameters
optlist = {};
if doplot
    optlist{1} = 'plot';
end

%compute histograms and plot
varargout = cell(1,max(1,nargout));
[varargout{:}] = hist_cell(C,  binz, 'labels', labels, optlist{:}, varargin{:});