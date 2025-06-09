%%[Ymean Yste]=meanseparen(Y,tabX,extrait)
%%calcule les moyennes (et ste) d'en tableau en sŽparant
%%les valeurs en fonction des valeurs de n tableaux d'entiers rentrŽs comme vecteurs colonnes de la matrice tabX (utilise
%%la fonction separen.m
%%on peut mettre un troisime argument: restreindre l'analyse ˆ un
%%sous-ensemble des donnŽes
%%[Ymean Yste Xin]=meansepare(Y,tabX,extrait,1) prŽsente les donnŽes autrement, en une
%%vecteur dont la premire colonne vaut la moyenne pour la combinaison de
%%paramtres donnŽes sur la mme ligne dans la matrice Xin
%
%
%ecrire une même fonction pour grpmean, grpsum, etc.
%
%grpmean(..., 'max', [m1 m2 ..mn])
%(use 0 to ignore at that position)
%
%only deals with dim = 2

function [Ysum gnames] = sumseparen(Y,tabX,varargin)

warning('sumseparen : use grpsum instead');

subset = [];
maxvalue = [];

%processing of parameters
if nargin >=3,
    %subset
    if isnumeric(varargin{1}) || islogical(varargin{1})
        subset = varargin{1};
        v = 2;
    else
        v = 1;
    end
    
    %other parameters
    while v+2 <= nargin
        if ~ischar(varargin{v})
            error('unsupported parameter type for parameter #%d',v+3);
        end
        switch varargin{v}
            case 'max'
                v = v+1;
                maxvalue = varargin{v};
            case {'dim', 'dimension'}
                v = v+1;
                dim = varargin{v};
                error('dim not yet implemented');
            otherwise
                error('unknown parameter #%d',v+3);
        end
        v = v+1;
    end
    
end

if ~isempty(subset),  %use only subset of data
    Y = Y(:,subset);
    tabX = tabX(:,subset);
end

%if just counting number of elements in each group
if nargin==1,
    tabX = Y;
    Y = ones(1,length(tabX));
end

%replace groups by indices
Idx = zeros(size(tabX));
ngroups = size(tabX,1);
gnames = cell(1, ngroups);
for g=1:ngroups
    [Idx(g,:) gnames{g}] = grp2idx(tabX(g,:));
end

%group data
Z = grpn(Y,Idx);

if isempty(maxvalue), %default size
    
    %compute sum
    Ysum = cellfun(@sum, Z);
    
else
    
    %size of output argument
    siz = zeros(1,ngroups);
    gpos = cell(1, ngroups);
    for g = 1:ngroups
        if maxvalue(g)~=0,
            gpos{g} = str2double(gnames{g});
            siz(g) = maxvalue(g);
            gnames{g} = cellfun(@num2str, num2cell(1:maxvalue(g)), 'UniformOutput', false);
            if max(gpos{g}) > maxvalue(g),
                error('maximum value in X larger than fixed largest value %d', maxvalue);
            end
        else
            siz(g) = length(gnames{g});
            gpos{g} = 1:siz(g);
        end
    end
    
    %create output argument
    Ysum = zeros(siz);
    
    %compute sum and assign to appropriate indices
    Ysum(gpos{:}) = cellfun(@sum, Z);
    
end



