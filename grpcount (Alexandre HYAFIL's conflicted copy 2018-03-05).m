function [Z, gnames] = grpcount(G, d, subset, maxvalue, doplot, varargin)
%Z = grpcount(G) counts the number of each element in group G.
%G can be a grouping variable (categorical, numeric, or logical vector; a cell vector of
%strings) or a vector cell array of grouping variables of same length.
%Type "help groupingvariable" for more information about grouping
%variables.
%
%Z = grpcount(G, d) to work along dimension d (by default : first
%non-singleton dimension)
%
%Z = grpcount(G, d, subset) to use a subset
%
%Z = grpcount(G, d, subset, maxvalue)
%
%Z = grpcount(G, d, subset, maxvalue, 'plot')
%Z = grpcount(G, d, subset, maxvalue, 'plot', plotoptions) to use wu plot
%options (type help wu)
%
%See also grpn, grpsum, grpn, grphist, grp2idx

%!! add histc/quantiles options

%by default : first non-singleton dimension
if nargin<2 || isempty(d),
   d = find(size(G)>1,1);
   if isempty(d),
       d = 1;
   end
end

% % i dont know where this comes from but will likely create some shit now
% % that i've added dimension parameter
% if isvector(G) && size(G,2)==1,
%     G = G(:)';
%     d = 2;
% end

if nargin<3,
    subset = [];
end
if nargin<4,
    maxvalue = [];
end
if nargin<5,
    doplot = '';
end

% if not cell format : create cell 
if ~iscell(G) || ischar(G{1}),
    justonegroup = 1;
    G = {G};
else 
    justonegroup = 0;
end


% % if not cell format : creat cell where each element is a line of G
% if ~iscell(G) || ischar(G{1}),
%     justonegroup = 1;
%     G = num2cell(G,2)';
% else 
%     justonegroup = 0;
% end

%create vector of ones
if isvector(G{1})
    l = length(G{1}); %% should also sort this mess
else
    l = size(G{1},d);
end
siz = ones(1,ndims(G{1}));
siz(d) = l;
Y = ones(siz);
%Y = ones(l,1);

%group
[C, gnames] = grpn(Y, G, subset, d, maxvalue);

%count
Z = cellfun(@numel, C);

%group names 
if isnumeric(G),
   gnames = cellfun(@(x) cellfun(@str2double,x)', gnames, 'UniformOutput', false); 
end


%plot
if nargin>=4 && strcmp(doplot, 'plot')
   wu(Z, [], gnames, varargin{:});   
end

if justonegroup,
    gnames = gnames{1};
end