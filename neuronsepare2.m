function [Mmin Mstd ploth ]=neuronsepare2(Ne, num, A, B, debuenreg, finenreg, plotte, extrait)
%[Mmin Mstd]=neuronsepare2(Ne, num, A, B, debuenreg, finenreg, plotte)

%colaz = defcolor;
glob
colaz = {BLUE, RED, GREEN, ORANGE, DARKBLUE, DARKRED, DARKGREEN, BROWN};

if nargin == 8,
    extrait = extrait(debuenreg:finenreg);
else 
    extrait = true(1,finenreg-debuenreg+1);
end
    

[Mmin Mstd]=meansepare2(Ne(:,:,num), A(debuenreg:finenreg), B(debuenreg:finenreg), extrait);
Mmin=permute(Mmin, [3 1 2]); % d'abord selon B, puis time, puis A
Mstd=permute(Mstd, [3 1 2]);

if plotte,
    for k=1:max(B)
        for l=1:max(A)
    ploth(k,l) = pc(Mmin(:,l,k), colaz{1+mod(k-1,7)},'-', 1/2+l/2);
    hold on;
        end
    end
end