function tabsorty=melange(tabentre ,nbextrac, modd, parepet)
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

l=length(tabentre);
if nargin==1, nbextrac=l; end
tabsorty=zeros(1,nbextrac);
if nargin<=2, modd=0; end

if modd<2 %on m�lange le tableau

    if nargin<4,  %sans l'option parepet



        if nbextrac<=l  % le cas normal

            for i=1:nbextrac
                place= i+floor(rand*(l-i+1)); % echange le i�me �l�ment avec un � la place 'place' situ� apr�s
                tampon=tabentre(i);
                tabentre(i)=tabentre(place);
                tabentre(place)=tampon;
                tabsorty=tabentre(1:nbextrac);
            end
        else %plus de valeurs demand�es que la taille du probl�me
            if modd==0 %%on d�coupe le probl�me
                for j=1:ceil(nbextrac/l)
                    tabinter((j-1)*l+1:min(j*l,nbextrac))=melange(tabentre,min(l,nbextrac-(j-1)*l)); %on rajoute un tableau entier m�lang�, ou bien juste un bout le dernier coup
                end
                tabsorty=tabinter(1:nbextrac);
            else %modd=1, on m�lange le tableau des indices et on affecte � chaque indice un �l�ment du tableau
                blop=melange(1:nbextrac);
                blop=mod(blop,l)+1; %il reste donc l �l�ments diff�rents
                tabentre=melange(tabentre); %on rem�lange tabentre pour pas favoriser les premiers �l�ments (rapport au modulo)
                tabsorty=tabentre(blop); %on affecte un �l�ment de tabentre � chaque �l�ment de blop
            end
        end


    else %avec l'option parepet

        recommence=1;
        while recommence
            tabsorty=melange(tabentre,nbextrac,modd);
            if parepet>=0  %
                recommence=0;
                for m=1:parepet
                    recommence=recommence+sum(tabsorty==decale(tabsorty,m));  %onn rajoute le nb de fois o� ya un m�me �l�ment d�cal� de m places
                end
            else % pas une valeur trop de fois d'affilee
                recommence=affilee(tabsorty,-parepet);
            end
        end
    end



else  %en mode2, choisit chaque �l�ment ind�pendamment

    if nargin==3,parepet=0; end

    tabsorty=tabentre;   %juste pour que si c'est caract�res, tabsorty soit aussi de type string
    for place=1:nbextrac,
        if parepet>=0,  %exclure les parepet-1 derniers �l�ments du tirage
            exclusset=tabsorty(max(place-parepet,1):place-1);
        else   %exclure un �l�ment si r�p�t� dans les -parepet-1 derniers �l�ments
            exclusset=[];
            if  (place>=-parepet)&&(affilee(tabsorty(place+parepet+1:place-1),-parepet-1)), exclusset=tabsorty(place-1); end
        end
        tabpos=setdiff(tabentre,exclusset);
        tabsorty(place)=tabpos(ceil(rand*length(tabpos)));
    end
    tabsorty=tabsorty(1:nbextrac);
end