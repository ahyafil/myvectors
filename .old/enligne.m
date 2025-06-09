function [numat, regress] = enligne(mat, doexpand)
%[numat regress]= enligne( mat) takes a n-dim matrix and turns it into a
%vector. the positions of vector elements in the original matrix appear in
%matrix regress, each line accounting for a dimension of the dimension

%for numeric cells , enligne(mat, 'expand') to convert into a vector


doexpand = nargin==2 && strcmp(doexpand, 'expand');

warning('enligne : use x(:) and fullfact/ind2sub instead');

if ~doexpand


    siz = size(mat);
    ndim = length(siz);

    numat(1,:)= reshape( mat, [1 prod(siz)]); %vectorize the initial matrix

    if nargout>=2

        %construct matrices which vary only on one of the ndim dimensions
        for d=1:ndim
            nushape = ones(1,ndim);
            nushape(d) = siz(d);
            vect = reshape([1:siz(d)], nushape); %so we have a 'vector' from 1 : siz(d), except than it's on the dth dimension
            siz2 = siz;
            siz2(d) =1 ;
            dimmat{d} = repmat( vect, siz2);    %we tile this vector so that it has the same dimension as mat
        end

        for d=1:ndim
            regress(d,:) = reshape(dimmat{d}, [1 prod(siz)]);        %and add our ndim 'regressors'
        end

    end

else   %cell

    one = ones(size(mat));
    [dum reg2] = enligne(one);

    numat = [];
    regress = [];

    for i=1:numel(mat);
        numat = [numat mat{i}];
        for k=1:length(mat{i}),
            regress(:, end+1) = reg2(:,i);
        end
    end
end