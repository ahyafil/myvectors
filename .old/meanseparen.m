%%[Ymean Yste]=meanseparen(Y,tabX,extrait)
%%calcule les moyennes (et ste) d'en tableau en sŽparant
%%les valeurs en fonction des valeurs de n tableaux d'entiers rentrŽs comme vecteurs colonnes de la matrice tabX (utilise
%%la fonction separen.m
%%on peut mettre un troisime argument: restreindre l'analyse ˆ un
%%sous-ensemble des donnŽes



function [Ymean Yste nbchq]=meanseparen(Y,tabX,extrait, resiz)

if (nargin>=3)&&(length(extrait)),  %ne garder qu'un extrait
    Y=Y(:,extrait);
    tabX=tabX(:,extrait);
end

warning('off','MATLAB:colon:logicalInput')
warning('off','MATLAB:divideByZero')
Z=separen(Y,tabX);


Ymean = cell(size(Z));

for i = 1:numel(Ymean),
    Ymean{i} = mean(Z{i},2);
end
Ymean = cell2mat(Ymean);

if size(Y,1) > 1, %if different measures
    Ymean = reshape(Ymean, [size(Y,1) size(Z)]);
end


if nargout >=2
    Yste = cell(size(Z));
    for i = 1:numel(Ymean),
    Yste{i} = ste(Z{i},2);
end
Yste = cell2mat(Ymean);

if size(Y,1) > 1, %if different measures
    Yste = reshape(Yste, [size(Y,1) size(Z)]);
end

     if nargout >= 3,
         nbchq = cellfun(@length, Z);
     end
 end

% Ymean = cellfun(@mean, Z, 'UniformOutput', 'false');
% if nargout>=2,
%     Yste = cellfun(@ste, Z);
%     if nargout >= 3,
%         nbchq = cellfun(@length, Z);
%     end
% end
