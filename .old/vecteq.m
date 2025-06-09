function b = vecteq(X, Y)
% !! use isqual directly instead
%vecteq(X, Y) is true only if X and Y are equal matrices
%(same size, same elements)
%first parameter can also be a cell of arrays, and Y is compared to all
%of them (the output is then a boolean matrix the size of the cell
%
%
error('use isequal instead');

if iscell(X)
    b = cellfun(@(x) isequal(x, Y), X);
    
else
    warning('use isequal instead');

    b= isequal(X,Y);
end