%affilee(x,n) avec x vecteur et n entier >1
%renvoie le nombre de fois où n éléments successifs de x sont égaux
%[ya pos val]=affilee(x,n) 
%renvoie dans pos la position du premier de ces éléments pour chaque série 
%renvoie dans val les valeurs de x à chacune de ces positions

function [ya pos val]=affilee(x,n);
same(1,:)=ones(1,length(x));
autre=min(x)-1;  %nb qu'on va mettre à la fin des vectuers décalés
for i=2:n
    same(i,:)=1*(x==decale(x,-i+1,1,autre)); %si ya egalite entre éléments distants de i
end
isaffilee=prod(same);  %vaut donc 1 à un endroit si les n valeurs suivantes sont les mêmes
ya=sum(isaffilee);
pos=find(isaffilee);
val=x(pos);