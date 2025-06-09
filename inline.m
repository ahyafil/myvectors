function numat = inline( mat)

warning('inline : use something else');

siz = size(mat);
ndim = length(siz);

%construct matrices which vary only on one of the ndim dimensions
for d=1:ndim
    nushape = ones(1,ndim);
    nushape(d) = siz(d);
    vect = reshape([1:siz(d)], nushape); %so we have a 'vector' from 1 : siz(d), except than it's on the dth dimension
    siz2 = siz;
    siz2(d) =1 ;
    dimmat{d} = repmat( vect, siz2);    %we tile this vector so that it has the same dimension as mat
end

numat(1,:)= reshape( mat, [1 prod(siz)]); %vectorize the initial matrix

for d=1:ndim
    numat(d+1,:) = reshape(dimmat{d}, [1 prod(siz)]);        %and had our ndim 'regressors'
end