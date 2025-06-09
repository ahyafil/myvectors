function mat = squize(mat)

mat = squeeze(mat);

if isvector(mat),
    mat=mat';
end