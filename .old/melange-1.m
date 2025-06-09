function tabsorty=melange(tabentre ,nbextrac, modd, parepet)
% melange(tableau [,nb à extraire] [,mode]) mélange complètement le tableau d'entrée
% et renvoie en sortie le nb  d'éléments spécifié par l'utilisateur (à
% défaut toutes les valeurs
%
%*différents modes:
%-0 (par défaut): un élément n'est utilisé qu'une fois ; si le nb rentré est supérieur au nb d'éléments,
%alors complète en utilisant autant de fois le tableau que nécessaire
%-1 (pas codé): un élément n'est utilisé qu'une fois ; si le nb rentré est supérieur au nb d'éléments,
%melange le tableau des nb entiers puis réaffecte avec un modulo chaque élément à l'emplacement correspondant
%-2: chaque élément est tiré au sort indépendamment
% melange (tableau, nb, m) s'assure qu'un élément ne soit répété dans les m
% éléments suivants
% melange(tableau, nb, -m) s'assure qu'un élément ne soit pas répété n fois
% d'affilee

l=length(tabentre);
if nargin==1, nbextrac=l; end
tabsorty=zeros(1,nbextrac);
if nargin<=2, modd=0; end

if modd<2 %on mélange le tableau

    if nargin<4,  %sans l'option parepet



        if nbextrac<=l  % le cas normal

            for i=1:nbextrac
                place= i+floor(rand*(l-i+1)); % echange le ième élément avec un à la place 'place' situé après
                tampon=tabentre(i);
                tabentre(i)=tabentre(place);
                tabentre(place)=tampon;
                tabsorty=tabentre(1:nbextrac);
            end
        else %plus de valeurs demandées que la taille du problème
            if modd==0 %%on découpe le problème
                for j=1:ceil(nbextrac/l)
                    tabinter((j-1)*l+1:min(j*l,nbextrac))=melange(tabentre,min(l,nbextrac-(j-1)*l)); %on rajoute un tableau entier mélangé, ou bien juste un bout le dernier coup
                end
                tabsorty=tabinter(1:nbextrac);
            else %modd=1, on mélange le tableau des indices et on affecte à chaque indice un élément du tableau
                blop=melange(1:nbextrac);
                blop=mod(blop,l)+1; %il reste donc l éléments différents
                tabentre=melange(tabentre); %on remélange tabentre pour pas favoriser les premiers éléments (rapport au modulo)
                tabsorty=tabentre(blop); %on affecte un élément de tabentre à chaque élément de blop
            end
        end


    else %avec l'option parepet

        recommence=1;
        while recommence
            tabsorty=melange(tabentre,nbextrac,modd);
            if parepet>=0  %
                recommence=0;
                for m=1:parepet
                    recommence=recommence+sum(tabsorty==decale(tabsorty,m));  %onn rajoute le nb de fois où ya un même élément décalé de m places
                end
            else % pas une valeur trop de fois d'affilee
                recommence=affilee(tabsorty,-parepet);
            end
        end
    end



else  %en mode2, choisit chaque élément indépendamment

    if nargin==3,parepet=0; end

    tabsorty=tabentre;   %juste pour que si c'est caractères, tabsorty soit aussi de type string
    for place=1:nbextrac,
        if parepet>=0,  %exclure les parepet-1 derniers éléments du tirage
            exclusset=tabsorty(max(place-parepet,1):place-1);
        else   %exclure un élément si répété dans les -parepet-1 derniers éléments
            exclusset=[];
            if  (place>=-parepet)&&(affilee(tabsorty(place+parepet+1:place-1),-parepet-1)), exclusset=tabsorty(place-1); end
        end
        tabpos=setdiff(tabentre,exclusset);
        tabsorty(place)=tabpos(ceil(rand*length(tabpos)));
    end
    tabsorty=tabsorty(1:nbextrac);
end