function Y = melange(X ,N, modd, norepeat)
% melange(tableau [,nb à extraire] [,mode]) mélange complètement le tableau d'entrée
% et renvoie en sortie le nb  d'éléments spécifié par l'utilisateur (à
% défaut toutes les valeurs
%
%*différents modes:
%-0 (par dÈéfaut): un ÈélÈément n'est utilisÈé qu'une fois ; si le nb rentré est supérieur au nb d'éléments,
%alors complète en utilisant autant de fois le tableau que nécessaire
%-1 (pas codé): un élément n'est utilisé qu'une fois ; si le nb rentré est supérieur au nb d'éléments,
%melange le tableau des nb entiers puis réaffecte avec un modulo chaque élément à l'emplacement correspondant
%-2: chaque élément est tiré au sort indépendamment
% melange (tableau, nb, m) s'assure qu'un élément ne soit répété dans les m
% éléments suivants
% melange(tableau, nb, -m) s'assure qu'un élément ne soit pas répété n fois
% d'affilee
%
%See also RANDSAMPLE, SHUFFLE, RANDOMIZER

if nargin<3, modd=0; end
if nargin<4,norepeat = 0; end

if size(X,1)>1,
    XX = 1:size(X,2);
    Y = X(:,melange(XX, N, modd, norepeat));
    return
end



l=length(X);
if nargin==1, N=l; end
Y=zeros(1,N);


if modd<2 %on mélange le tableau
    
    if ~norepeat,  %sans l'option norepeat
        
        
        if N<=l  % le cas normal
            
            for i=1:N
                place= i+floor(rand*(l-i+1)); % echange le ième élément avec un à la place 'place' situé après
                tampon=X(i);
                X(i)=X(place);
                X(place)=tampon;
                Y=X(1:N);
            end
        else %%on découpe le problème
            for j=1:ceil(N/l)
                tabinter((j-1)*l+1:min(j*l,N)) = melange(X,min(l,N-(j-1)*l)); %on rajoute un tableau entier mélangé, ou bien juste un bout le dernier coup
            end
            Y=tabinter(1:N);
        end
        
        
    else %avec l'option norepeat
        
        repeat=1;
        while repeat
            Y=melange(X,N,modd);
            if norepeat>0  %
                repeat=0;
                for m=1:norepeat
                    repeat = repeat + sum(Y==decale(Y,m));  %onn rajoute le nb de fois où ya un même élément décalé de m places
                end
            else % pas une valeur trop de fois d'affilee
                repeat = affilee(Y,-norepeat);
            end
        end
    end
    
    
    
else  %en mode2, choisit chaque élément indépendamment
    
    
    Y=X;   %juste pour que si c'est caractères, Y soit aussi de type string
    for place=1:N,
        if norepeat>=0,  %exclure les norepeat-1 derniers éléments du tirage
            exclusset=Y(max(place-norepeat,1):place-1);
        else   %exclure un élément si répété dans les -norepeat-1 derniers éléments
            exclusset=[];
            if  (place>=-norepeat)&&(affilee(Y(place+norepeat+1:place-1),-norepeat-1)),
                exclusset=Y(place-1);
            end
        end
        tabpos=setdiff(X,exclusset);
        Y(place)=tabpos(ceil(rand*length(tabpos)));
    end
    Y=Y(1:N);
end