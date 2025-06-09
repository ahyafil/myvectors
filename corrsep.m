%%[zscore pscore rscore] = corrsep(Y1, Y2, tabX [,extrait] [,'plot'] [,{Y1name Y2name}])

function [zscore pscore rscore nbelem]=corrsep(Y1, Y2, tabX, varargin)

plotte=0; %default
varname = {'Y1' 'Y2'};
dopartial = 0;

v=1;
while v <= length(varargin)
    varg = varargin{v};
    switch class(varg)
        case {'double' 'logical'}, %ne garder qu'un extrait
            Y1 = Y1(:,varg);
            Y2 = Y2(:,varg);
            tabX = tabX(:,varg);
        case 'char'
            switch varg,
                case 'plot', plotte=1;
                case 'partial',
                    v=v+1;
                    dopartial = 1;
                    Y3 = varargin{v};
            end
        case 'cell'
            varname = varg;
    end
    v = v +1;
end

%sŽparer les valeurs de Y1 et Y2 en fonction des valeurs de tabX
Z1 = separen(Y1, tabX);
Z2 = separen(Y2, tabX);
nbelem = cellfun(@length, Z1);
if dopartial,
    Z3 = separen(Y3, tabX);
end

zscore = NaN(size(Z1));
pscore = NaN(size(Z1));
rscore = NaN(size(Z1));
absc   = cell(size(Z1));
ords   = cell(size(Z1));

%calculer valeurs p et z pour chaque combinaison de valeurs de tabX
for i=1:numel(Z1)
    if dopartial,
        [r p] = partcorrcoef(Z1{i}', Z2{i}', Z3{i}');
    else
        [r p] = corrcoef(Z1{i}, Z2{i});
    end
    if length(Z1{i})>1
        if ~dopartial
            p = p(1,2);
            r = r(1,2);
        end
        pscore(i) = p;
        rscore(i) = r;
        [rci sig z] = r2z( r,length(Z1{i}));
        zscore(i) = z;
        [ords{i} absc{i}] = fitxy(Z1{i}, Z2{i},1);
    else
        pscore(i) = NaN; rscore(i) = NaN; zscore(i) = NaN;
        ords{i}=0; absc{i}=0;
    end
end

%plotter si demander (et pas plus de 3facteurs)
if plotte & size(tabX,1)<=3
    clf; hold on;
    colaz = defcolor;
    siz = [1 1 1];
    siz(1:ndims(Z1)) = size(Z1);
    for s3 = 1:siz(3)
        for s2 = 1:siz(2)
            [dem nsub1 nsub2] = subplot2( siz(3), siz(2), s3 , s2);
            for s1 = 1:siz(1);
                hold on;
                plot( Z1{s1, s2, s3}, Z2{s1, s2, s3}, 'Color', colaz{s1}, 'Marker', '.', 'LineStyle', 'none', 'MarkerSize', 10);
%                if siz(1)==1, title(['p=' num2str(pscore(s1, s2, s3))]); end
                if siz(1)==1, title(['r=' num2str(rscore(s1, s2, s3))]); end
                plot(absc{s1, s2, s3}, ords{s1, s2, s3}, 'Color', colaz{s1}, 'LineWidth',2);
                xlabel(varname{1});
                xlabel(varname{2});
                whichsign = find(pscore(:,s2,s3)<.05);
                if  find(s1==whichsign) & length(whichsign) <=2
                    if find(s1==whichsign) ==1,
                        posx = absc{s1, s2, s3}(end);
                        posy = ords{s1, s2, s3}(end);
                    else
                        posx = absc{s1, s2, s3}(1);
                        posy = ords{s1, s2, s3}(1);
                    end
                  % text(posx, posy, ['p=' num2str(pscore(s1, s2, s3),4)], 'Color', colaz{s1},  'FontSize', 12);
                    text(posx, posy, ['r=' num2str(rscore(s1, s2, s3),4)], 'Color', colaz{s1},  'FontSize', 16);
                end
            end
        end
    end
    gcfpos = get(gcf, 'Position');
    set(gcf, 'Position', [gcfpos(1:2) 250*nsub1 200*nsub2]);
end

if isvector(zscore),
    zscore = zscore';
    pscore = pscore';
    rscore = rscore';
end