function [Mmin Mstd]=neuronsepare2(Ne, num, A, B, debuenreg, finenreg, plotte)


[Mmin Mstd]=meansepare2(Ne(:,:,num), A(debuenreg:finenreg), B(debuenreg:finenreg));
Mmin=permute(Mmin, [1 3 2]); % d'abord selon B, puis time, puis A
Mstd=permute(Mstd, [1 3 2]);

if plotte,
    plot(Mmin);
end