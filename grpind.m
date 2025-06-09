function [I, gLabel] = grpind(G, subset, maxvalue)
%I = grpind(G) provides indices for elements in each group defined by G.
%G can be a grouping variable (categorical, numeric, or logical vector; a cell vector of
%strings) or a vector cell array of grouping variables of same length.
%Type "help groupingvariable" for more information about grouping
%variables.
%
%I = grpind(G, subset) to use a subset
%
%I = grpind(G, subset, maxValue) 
%
%[I gLabel] = grpind(...)
%
%See also GPRN, GCOUNT, GRP2IDX

if iscolumn(G)
    G = G(:)';
end
if nargin<2
    subset = [];
end
if nargin<3
    maxvalue = [];
end

% if not cell format : creat cell where each element is a line of G
if ~iscell(G)
    G = num2cell(G,2)';
end

%vector of ones
l = length(G{1});
II = 1:l;  %vector of all indices

%group
[I, gLabel] = grpn(II, G, subset, 2, maxvalue);

%count
if isnumeric(G)
   gLabel = cellfun(@(x) cellfun(@str2double,x)', gLabel, 'UniformOutput', false); 
end