%affilee(x,n) avec x vecteur et n entier >1
%renvoie le nombre de fois o� n �l�ments successifs de x sont �gaux
%[ya pos val]=affilee(x,n) 
%renvoie dans pos la position du premier de ces �l�ments pour chaque s�rie 
%renvoie dans val les valeurs de x � chacune de ces positions

function [ya pos val]=affilee(x,n);
same(1,:)=ones(1,length(x));
autre=min(x)-1;  %nb qu'on va mettre � la fin des vectuers d�cal�s
for i=2:n
    same(i,:)=1*(x==decale(x,-i+1,1,autre)); %si ya egalite entre �l�ments distants de i
end
isaffilee=prod(same);  %vaut donc 1 � un endroit si les n valeurs suivantes sont les m�mes
ya=sum(isaffilee);
pos=find(isaffilee);
val=x(pos);