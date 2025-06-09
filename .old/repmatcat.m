function Y = repmatcat(A, M, d)
%Y = repmatcat(A, M) replicates element each element A(i) of vector A M(i) times and
%concatenates the result into single line vector
%
%Y = repmatcat(A, M, dim) to replicate and concatenate along dimension DIM
%
%Y = repmatcat(C, M) or repmatcat(C,M, dim) to replicate and concatenate
%each element of cell array C. Y is converted to numerical array unless
%elements of C are string arrays


if nargin<3,
    d = 2;
end

if ~iscell(A),
    A = num2cell(A, setdiff(1:ndims(A),d));
end

if ischar(A{1}),
   keepcell = 1;
   A = cellfun(@(x) {x}, A, 'Uniformoutput', false);
end

%replicate each element
rep = ones(1,ndims(A));
for i = 1:numel(A),
    rep(d) = M(i);
    A{i} = repmat(A{i}, rep);
end

%convert to matrix
if ~keepcell
    Y = cell2mat(A);
else
    A = catcell(d, A, d);
    Y = cellfun(@(x) x{1}, A, 'Uniformoutput', false);
end