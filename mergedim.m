function X = mergedim(X, dim)
%Y = mergedim(X, DIM) merge dimensions indicated in vector DIM in array X
%dimensions are merged into the first dimension in vector dim
%other dimensions in DIM become singleton dimensions
%
%example mergedim(rand(2,3,4,5),[2 4]) is a 2-by-15-by-4 matrix

if length(unique(dim)) < length(dim)
   error('dimensions cannot be repeated in vector DIM'); 
end

%newd = dim(1);
%oldd = dim(2:end);
nd = length(dim);

%permute to place merging dimensions as final dimensions in X 
ndim = ndims(X);
perm = [setdiff(1:ndim,dim) dim];  %permutation vector
X = permute(X, perm);

%merge dimensions
newsiz = size(X);
newsiz(ndim-nd+1) = prod(newsiz(ndim-nd+1:ndim));
newsiz(ndim-nd+2:end) = [];
if length(newsiz)==1,
    newsiz = [newsiz 1];
end
X = reshape(X, newsiz);

%permute back
X = ipermute(X, perm);
