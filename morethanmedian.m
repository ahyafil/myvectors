function [Z Ymean]=morethanmedian(Y, matX, extrait)
%[Z Ymean]=morethanmedian(Y, matX) returns a boolean vector
%having true for all Y values thare are greater than their related
%sub-median value( grouped according to the values in matX )


if nargin>=3,
    Yin=Y(:,extrait);
    matXin=matX(:,extrait);
else
    Yin=Y;
    matXin=matX;
    extrait = size(Y);
end

Ymedian = medianseparen(Yin, matXin);


Zin=zeros(size(Yin));
for i=1:length(Yin)
    coords = num2cell(matXin(:,i)');
    Zin(i) = Yin(i)> Ymedian(coords{:});
end

Z = -ones(size(Y));
Z(extrait)=Zin;