%fonction qui extrait les valeurs successives d'un tableau 2xt selon si la
%1ère ou la deuximère valeur était +grande i trials avant
%autocorrel(tableau, nb de trials en arrière où va chercher
%l'autcorrelation, 0/1 plot/pas de plot, éventuellement sous ensemble à extraire du tableau)

function autok = autocorrel(X,n, ploplot, extrait)



coulaz=defcolor;
tipplot=['--';'- '];


if nargin>3,
    X = X(:,extrait);
end
if isvector(X)
    X = replace(X);
    XX = zeros(max(X), length(X));
    for i = 1:length(X), XX(X(i),i) = 1; end
    X = XX;
end
siz = size(X);

plugran=maxpos(X);
for i=1:n
    if nnz(plugran(1:end-i))&nnz(1-plugran(1:end-i)) %si ya des trials avec les 2cas (le premier sup et le deuxième sup)
        tabavant= decale(plugran,i);  %on introduit i zéros avant pour décaler d'autant
        for l = 1:siz(1),
            autok(l,:,i) = meansepare(X(l,:), (tabavant==l)+1, [],2);
        end
    else %si c tuojours le même le +grand
        autok(:,:,i) = mean(X,2)*ones(1,siz(1));
    end
    %plotautok(i,:,:)=autok(:,:,i);

end

plotautok = permute(autok, [1 3 2]);

if ploplot,
    hold on;
    for m=1:2
        pc(plotautok(:,:,m), coulaz, tipplot(m,:));
    end
end