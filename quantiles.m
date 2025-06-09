function [Z, B] = quantiles(Y, n, G, subset)
%quantiles(Y, n) bins values of Y into n quantiles and
%assigns in Z the corresponding quantile of each value of Y
%
%Alteratively, use quantiles(Y, prop) where prop is a vector of edges
%(monotically increasing) between 0 and 1.
%
%quantiles(Y, n, G) to define quantiles separately for each group using
%grouping variable G
%
% quantiles(Y, n, [],subset) or quantiles(Y, n, G,subset) to use subset of
% values
%
%[Z prop] = quantiles(...)
% Z is the vector of quantile values. prop is the vector of edges.
%
% See also DISCRETIZE, GFUN

if nargin>=4
    Yin = Y(:,subset);
    Gin = G(:,subset);
else
    if nargin<3
        G = ones(size(Y));
    end
    Yin = Y;
    Gin = G;
    subset = 1:length(Y);
end

%turn into edges vector if required
if length(n)==1 && n>=1
    prop = 0: 1/n :1;
    prop(end) =[];
else
    prop =n;   %already a vector
end

if isempty(Yin)
    Z = Yin;
    return;
end

for s=1:size(G,1)
    %  Gin(s,:) = replace(Gin(s,:));
    Gin(s,:) = grp2idx(Gin(s,:));
end

%group data if required
if nargin>=3 && ~isempty(Gin)
    A = grpn(Yin, Gin);
    returncell = 1;
else
    A = {Yin};
    returncell = 0;
end

%compute quantiles
B = cell(size(A));
for a=1:numel(A)
    if ~isempty(A{a})
        B{a} = quantile(A{a}, prop);
    else
        B{a} = NaN;
    end
end

%assign to each value of Y the associate quantile number
Zin = nan(size(Yin));
for i=1:length(Yin)
    if ~isnan(Yin(i))
        coords = num2cell(Gin(:,i)');
        Zin(i) = sum(Yin(i)>= B{coords{:}});
        if Zin(i)==0
            error('problem de script?')
        end
    end
end

Z = -ones(size(Y));
Z(subset) = Zin;

for a=1:numel(A) % avoid repeated values
    B{a} = unique(B{a});
end

if ~returncell
    B = B{1};
end