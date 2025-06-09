%fonction qui permet de recentrer les data d'enreg de neurones sur données
%de reactiontime ou tout autre évènement

function [Nout chifte]=RTlocked(Ne, RT)
[b a c]=size(Ne);
chifte=ceil(min(RT)/10); % on commence à calculer la série à partir de RT-chifte
fin=b-ceil(max(RT)/10);

Nout=zeros(chifte+fin,a,c);
for aa=1:a
    Nout(:,aa,:)= Ne(ceil(RT(aa)/10)-chifte+1:ceil(RT(aa)/10)+fin,aa,:);
end
