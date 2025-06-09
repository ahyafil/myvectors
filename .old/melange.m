function Y = melange(X ,N, modd, norepeat)
% melange(tableau [,nb � extraire] [,mode]) m�lange compl�tement le tableau d'entr�e
% et renvoie en sortie le nb  d'�l�ments sp�cifi� par l'utilisateur (�
% d�faut toutes les valeurs
%
%*diff�rents modes:
%-0 (par d�faut): un �l�ment n'est utilis� qu'une fois ; si le nb rentr� est sup�rieur au nb d'�l�ments,
%alors compl�te en utilisant autant de fois le tableau que n�cessaire
%-1 (pas cod�): un �l�ment n'est utilis� qu'une fois ; si le nb rentr� est sup�rieur au nb d'�l�ments,
%melange le tableau des nb entiers puis r�affecte avec un modulo chaque �l�ment � l'emplacement correspondant
%-2: chaque �l�ment est tir� au sort ind�pendamment
% melange (tableau, nb, m) s'assure qu'un �l�ment ne soit r�p�t� dans les m
% �l�ments suivants
% melange(tableau, nb, -m) s'assure qu'un �l�ment ne soit pas r�p�t� n fois
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


if modd<2 %on m�lange le tableau
    
    if ~norepeat,  %sans l'option norepeat
        
        
        if N<=l  % le cas normal
            
            for i=1:N
                place= i+floor(rand*(l-i+1)); % echange le i�me �l�ment avec un � la place 'place' situ� apr�s
                tampon=X(i);
                X(i)=X(place);
                X(place)=tampon;
                Y=X(1:N);
            end
        else %%on d�coupe le probl�me
            for j=1:ceil(N/l)
                tabinter((j-1)*l+1:min(j*l,N)) = melange(X,min(l,N-(j-1)*l)); %on rajoute un tableau entier m�lang�, ou bien juste un bout le dernier coup
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
                    repeat = repeat + sum(Y==decale(Y,m));  %onn rajoute le nb de fois o� ya un m�me �l�ment d�cal� de m places
                end
            else % pas une valeur trop de fois d'affilee
                repeat = affilee(Y,-norepeat);
            end
        end
    end
    
    
    
else  %en mode2, choisit chaque �l�ment ind�pendamment
    
    
    Y=X;   %juste pour que si c'est caract�res, Y soit aussi de type string
    for place=1:N,
        if norepeat>=0,  %exclure les norepeat-1 derniers �l�ments du tirage
            exclusset=Y(max(place-norepeat,1):place-1);
        else   %exclure un �l�ment si r�p�t� dans les -norepeat-1 derniers �l�ments
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