function [Z Ymean]=morethanmean(Y, matX)

Ymean = meanseparen(Y, matX);

Z=zeros(size(Y));
for i=1:length(Y)
    coords = num2cell(matX(:,i)');
    Z(i) = Y(i)> Ymean(coords{:});
end