function sortie=lissage(entree, nbpas)
%sortie=lissage(entree, nbpas)

%lisse les valeurs d'un tableau en moyennant sur avec nb de points pris �
%chaque fois sp�cifi�s par le 2�me param�tre

[a l]=size(entree);
gauche=ceil((nbpas-1)/2);  %nb de points � gauche qu'on prend
droite=floor((nbpas-1)/2);

entree=[entree(:,1)*ones(1, gauche) entree entree(:,l)*ones(1,nbpas)];

sortie=zeros(a,l);
for i=1:l
    sortie(:,i)=mean(entree(:,i: i + nbpas-1),2);
end

