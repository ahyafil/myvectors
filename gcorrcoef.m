%gcorrcoef(X1, X2, G) computes correlation coefficients between X1 and X2
%separately for each value in grouping variable G.
%
% [C, p] = gcorrcoef(...) provides p-values in p
% 
% See also CORRCOEF, GMEAN, GFUN
%%corrcoefsepare(Y1, Y2, X)  ou corrcoefsepare(Y1, Y2, X, extrait)

function [C, p]=gcorrcoef(X1, X2, G, subset)
if nargin==4
    X1=X1(:,subset);
    X2=X2(:,subset);
    G=G(:,subset);
end
Z1=grp(X1,G);
Z2=grp(X2,G);

C = zeros(1,max(G));
p = zeros(1,max(G));
for i=1:max(G)
    [r, this_p]=corrcoef(Z1{i},Z2{i});
    C(i)=r(1,2);
    p(i)=this_p(1,2);
end