function Y = repval(X, N,d)
%Y = repval(X, n)
% X is vector or matrix 
% N is single value of vector
%
% Y = [X(1)*ones(1,N(1) X(2)*ones(1,N(2)) ...]
%
%Y = repval(X, n, DIM) to work along dimension DIM (by default first
%non-singleton dimension)
%
% See also repmat, kron

error('use repelem or kron instead');

siz = size(X);
if nargin < 3,
    d = find(siz>1,1); % by default first non singleton dimension
    if isempty(d),
        d = 1;
    end
end

if length(N) ==1,
    N = N*ones(1,siz(d));
elseif length(N) ~= siz(d),
    error('N must be a single value of a vector whose length equals the number of elements in X along replicating dimension');
end

C = cumsum([0 N(:)']);

% allocate memory for Y
newsiz = siz;
newsiz(d) = C(end);
Y = zeros(newsiz);

% index within X and Y
Idx_X = cell(1,length(siz));
for k = 1:length(siz);
    Idx_X{k} = 1:siz(k);
end
Idx_Y = Idx_X;

repvec = ones(1,length(siz));

% fill in
for i=1:siz(d)
    Idx_X{d} = i;
    Idx_Y{d} = C(i)+1 : C(i+1); % index along replicating dimension
    
    repvec(d) = N(i);
    
    Y(Idx_Y{:}) = repmat( X(Idx_X{:}), repvec);
end