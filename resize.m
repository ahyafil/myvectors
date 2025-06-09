function tab = resize(tab, siz)
%tab = resize(tab, siz)
%resizes a N dimension matrix to the desired size, cutting values if n-th
%required dimension size is lower than actual, adding NaNs if longer
%use Inf to leave dimension size unchanged along a given dimension


for s=1:length(siz),
    if isinf(siz(s)),
        siz(s) = size(tab,s);
    end
end


[vec coords] = enligne(tab);

tab = NaN(siz);

for i=1:length(vec);
    if all(coords(:,i)'<= siz)
        cocell = num2cell(coords(:,i));
        tab(cocell{:}) = vec(i);
    end
end
        