%fonction qui permet de recentrer les data d'enreg de neurones sur donn�es
%de reactiontime ou tout autre �v�nement

function [Nout chifte]=RTlocked(Ne, RT)
[b a c]=size(Ne);
chifte=ceil(min(RT)/10); % on commence � calculer la s�rie � partir de RT-chifte
fin=b-ceil(max(RT)/10);

Nout=zeros(chifte+fin,a,c);
for aa=1:a
    Nout(:,aa,:)= Ne(ceil(RT(aa)/10)-chifte+1:ceil(RT(aa)/10)+fin,aa,:);
end
