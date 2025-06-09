function [Mmin Mstd ploth ]=neuronsepare2s(Ne, num, A, B, debuenreg, finenreg, plotte, extrait, eventz)
%[Mmin Mstd]=neuronsepare2(Ne, num, A, B, debuenreg, finenreg, plotte)
%scatter plot

%colaz = defcolor;
glob
colaz = {BLUE, RED, GREEN, ORANGE, DARKBLUE, DARKRED, DARKGREEN, BROWN};

if nargin >= 8 & ~isempty(extrait),
    extrait = extrait(debuenreg:finenreg);
else 
    extrait = true(1,finenreg-debuenreg+1);
end
    

Msep = separe2(Ne(:,:,num), A(debuenreg:finenreg), B(debuenreg:finenreg), extrait);

maxA = max(A); maxB = max(B);

if plotte,
    clf;
    for k=1:maxB
        for l=1:maxA
                Mmin(:,k,l) = mean(Msep{k,l},2);
                Mste(:,k,l) = ste(Msep{k,l}')';
                subplot2(2*max(A), max(B), 2*k,l);
           %subplot('position',[ (2*k-1)/maxA, (l-1)/maxB, 1/2/maxA, 1/maxB]); 
           
           maxX = size(Mmin,1);
            fill([1:maxX, maxX:-1:1], [Mmin(:,k,l)' zeros(1,maxX)],'k');  
            xlim([0, maxX]);
            subset(:,:,k,l) = Msep{k,l}(:,1:20);
        end
    end
sameaxis;

if nargin ==9,
          eventsep = separe2(eventz, A(debuenreg:finenreg), B(debuenreg:finenreg), extrait);
   end

    subset = subset/max(max(max(max(subset,[], 4),[],3),[],2),[],1);
   for k=1:max(B)
        for l=1:max(A)
            subplot2(2*maxA, maxB, 2*k-1,l);
            %subplot('position', [(2*k-2)/maxA, (l-1)/maxB, 1/2/maxA, 1/maxB]); 
            imagesc(subset(:,:,k,l)');
            axis off;
            if nargin ==9,
                hold on;
               for i=1:size(eventz,1)
                   for j=1:20,
                       
                       plot( eventsep{k,l}(i,j)*[1 1], [j-1 j], 'color', colaz{i});
                   end
               end
            end
        end
   end
end

cmap = gray;
colormap(cmap(64:-1:1,:))