%[C gLabels dim] = grpn(X, G [,subset] [,dim] [,maxvalue], [quantiles]) groups vector or
%matrix X values into different cells of C based on grouping vector G
%
%C{1,1,:,1} C{1,2} C{i1,i2,..in} etc...
%corresponds to values 1 2 etc in column vectors G1 ..
%Gn in matrix of indices G
%
% gLabels are the labels for each group
%
%grpn({G1,G2...Gn}) outputs a cell array with the indices for each group
%
%See also grp2idx, GMEAN, GCOUNT

%add :list of gnames instead of maxvalue

function [C, gLabel, dim] = grpn(X, G, subset, dim, maxValue, quants, his)
if nargin==1
    G = X;
    X = 1:length(G(1,:));
end
if nargin<3
    subset = [];
end
if nargin<4
    dim = [];
end
if nargin<5
    maxValue = [];
end

%if grouping variable is empty
if isempty(G)
    gLabel = {};
    if nargin < 4
        dim = find(size(G)==0, 1);
    end
    if nargin >= 5 && ~isempty(maxValue)
        siz = ones(1, max(dim,2));
        siz(dim) = maxValue;
        C = cell(siz);
    elseif nargin >= 7 && ~isempty(his)
        siz = ones(1, max(dim,2));
        siz(dim) = length(his)-1;
        C = cell(siz);
    else
        C = {};
    end
    return;
end

if ~iscell(G) || ischar(G{1})
    %  G = num2cell(G, 2)'; % convert to cell
    G = {G};
end
nPar = length(G); %number of parameters for grouping

%replace group values by quantiles if required
if (nargin <6) || isempty(quants)
    quants = cell(1,nPar);
elseif isnumeric(quants)
    quants = num2cell(quants); %mat2cell(quants);
end
if (nargin <7) || isempty(his)
    his = cell(1,nPar);
elseif isnumeric(his)
    his = {his};
end

%dimension of the groups
if  isempty(dim)
    if isvector(X)
        dim = find(size(X)>1)*ones(1,nPar);  %if vector : non-singleton dimension
        if isempty(dim) % scalar value
            dim = 2*ones(1,nPar);
        end
    else
        dim = 2*ones(1,nPar);                   %default : dim 2
    end
elseif length(dim) ==1
    dim = dim*ones(1,nPar);
    %else
    %making sure sure 'dim' is in ascending order it the easiest way no to
    %confuse with dimensions - probably a way to enable any kim
    % [dim isort] = sort(dim); %dim must be in ascending order
    % G = G(isort);
end

%use only subset of all data
if  ~isempty(subset)
    assert(all(dim==dim(1)),'cannot extract subset of data when grouping over multiple dimensions');
    if islogical(subset) && length(subset)~= size(X,dim(1))
        error('Length of boolean subset vector (%d) must be equal to size of X along the grouping dimension (%d)',length(subset), size(X,dim(1)));
    elseif ~islogical(subset) && max(subset)> size(X,dim(1))
        error('Values of subset vector must not be superior to size of X along the grouping dimension');
    end

    % extract values for data matrix X
    indX = cell(1,ndims(X));
    for i=1:ndims(X)
        indX{i} = 1:size(X,i);
    end
    indX{dim(1)} = subset;
    X = X(indX{:});
    %  X=X(:,subset);

    %extract subset values for grouping matrices
    for p=1:nPar
        if isvector(G{p})
            G{p}=G{p}(subset);
        else
            indX = cell(1,ndims(G{p}));
            for i=1:ndims(G{p})
                indX{i} = 1:size(G{p},i);
            end
            indX{dim(1)} = subset;
            G{p} = G{p}(indX{:});
        end
    end
    % if no value left, return
    if isempty(G{1})
        C = {};
        gLabel = {};
        return;
    end
end
nDim = ndims(X);

%% treat grouping variable with multiple dimensions
%if groups have multiple dimensions
%(still a problem : should not automatically use first non-singleton dim
%but use 'dim'
withdummy = 0;
dummypar = false(1,nPar);
nDummy = 1;
if ~all(cellfun(@isvector,G))
    if ~all(dim==dim(1))
        error('when using multidimensional groups, cannot group along different dimensions');
    end
    Gsiz = size(G{1});
    nsd_all = find(Gsiz>1); % non-singleton dimensions
    nsd = nsd_all;
    nsd(dim(1)) = [];  %exclude grouping dimension

    % turn grouping variables into vector
    for p=1:nPar
        if (ndims(G{p}) ~=length(Gsiz)) || ~all(size(G{p})==Gsiz)
            error('when using multidimensional groups, all grouping variables should have the exact same size');
        end
        G{p} = mergedim(G{p},nsd_all);
    end

    % add new grouping variable for each non-singleton dimension (except the grouping dimension)
    newG = cell(1,length(Gsiz));
    newdim = min(nsd(1),dim(1));
    [newG{:}] = ind2sub(Gsiz, 1:prod(Gsiz)); % create cell array with indices for each dimension in G
    peper = 1:length(Gsiz); peper(2) = newdim; peper(newdim) = 2;
    newG = cellfun(@(x) permute(x,peper), newG, 'uniformoutput',0); % into columns

    %%%%

    %for p=1:length(nsd_all)
    %    newG2{p} = 1:Gsiz(nsd_all(p));
    %end
    %%%%

    G = [G newG(nsd)];   % add  non-singleton dimensions (except the grouping dimension) to grouping cell array
    [~, ord] = sort([dim(1) (1:length(dim)-1)+length(Gsiz) nsd]);
    G = G(ord); % reorder grouping variable

    % modify X accordingly
    for p= nsd % for all non-singleton non-grouping dimension of grouping variables
        if (dim(1)<p) && (newdim < dim(1))
            X = mergedim(X,[newdim dim(1)]); % not too clear what this is...
        end

        % if X has singleton dimensions where grouping variable has non-singleton, repmat
        if size(X,p) ==1

            sizX = size(X);
            % fnsd = find(sizX>1,1); % first non-singleton dimension of X
            repX = ones(size(sizX));
            repX(dim(1)) = Gsiz(p);
            X = repmat(X, repX); %replicate along first non-singleton dimension of X
        elseif size(X,p) == Gsiz(p)  % otherwise reshape
            if p~=newdim
                X = mergedim(X, sort([newdim p ]));
            end
        else
            error('Size of X and G do not match along dimension %d', p);
        end
    end
    if all(nsd < dim(1))
        X = mergedim(X,[newdim dim(1)]);
    end

    %now feed that back into grpn
    % dim = [dim dim(1)*ones(1,length(nsd))];
    dim = newdim;
    quants = [quants cell(1,length(nsd))];
    his = [his cell(1,length(nsd))];
    maxValue = [maxValue zeros(1,length(nsd))];

    % let's comment this to avoid dummy grouping variables being treaten
    % equal as real ones
    [C, gLabel, dim] = grpn(X, G, subset, dim, maxValue, quants,his);
    dim(nsd) = nsd;
    return;
else
    nsd = [];
end



%%check size,
for p=1:nPar
    assert( length(G{p}) == size(X,dim(p)),...
        'Length of grouping variable #%d (%d) does not match size of X along dimension %d (%d)', p, length(G{p}), dim(p),  size(X,dim(p)) );
end

%% looks like this part is completely redundant with part above, and thus useless ... should we delete it?....
%process multiple-dimension grouping matrices
dim_rmv = [];
dim_rmvnew = [];
for p=1:nPar
    if ~isvector(G{p})
        warning('ok so that is used...how?');
        dimg = find(size(G{p})>1);  %non-singleton dimensions
        dimg = setdiff(dimg, dim(p));
        for d=1:length(dimg)
            pp = find(dim_rmv==dimg(d));  %if this dimension has already been pointed out
            if ~isempty(pp)
                if all(dim_rmv(pp) == dim(p))      %must be reshaped on the same dimension
                    dimg(d) = [];
                else
                    error('non consistent dimensions for multi-dimensional grouping variables');
                end
            end
        end
        dim_rmv = [dim_rmv dimg];    %dimensions to remove
        dim_rmvnew = [dim_rmvnew dim(p)*ones(1,length(dimg))];   %dimension where it should be reshaped
        G{p} = G{p}(:)';      %vectorize
    end
end
while ~isempty(dim_rmv)
    siz = size(X);
    dn = dim_rmvnew(1);
    pp = find(dim_rmvnew==dn);
    do = dim_rmv(pp);

    %replicate grouping vectors
    for p = find(dim==dn)
        if length(G{p}) == siz(dn)
            G{p} = repmat(G{p}(:)', 1, prod(siz(do)));
        end
    end
    for d = 1:length(do)
        whichp = find(dim==do(d));
        if isempty(whichp)   %if empty add a new parameter for that dimension
            newpar = repmat(1:siz(do(d)), prod(siz([dn do(1:d-1)])) , prod(siz(do(d+1:end))) );
            G{end+1} = newpar(:)';
            dim(end+1) = dn;
        else     %replicate existing grouping vectors along that dimension
            for p = whichp
                newpar = repmat(G{p}, prod(siz([dn do(1:d-1)])) , prod(siz(do(d+1:end))) );
                G{p} = newpar(:)';
                dim(p) = dn;
            end
        end
    end

    X = mergedim(X, [dn do]);  %merge all relevant dimensions in data matrix
    dim_rmv(pp) = [];
    dim_rmvnew(pp) = [];
end
%%..... end of the part that maybe should be removed


%% replace groups by indices
Idx = cell(1,nPar);
gLabel = cell(1,nPar);
nGroup = zeros(1,nPar); % number of groups for each parameter
for p=1:nPar
    if ~isempty(quants{p})  % replace grouping values by quantiles
        [Idx{p}, gLabel{p}] = quantiles(G{p}(:)', quants{p});

        Idx{p} = gidx(Idx{p}');
        gLabel{p} = num2strcell(gLabel{p}');
    elseif ~isempty(his{p})  % replace grouping values by binned data with histogram
        [~, Idx{p}] = histc(G{p}, his{p});
        Idx{p} = Idx{p}(:);
        Idx{p}( Idx{p}==length(his{p}) ) =length(his{p})-1; % add value for last zero-width bin to the one before
        Idx{p}(Idx{p}==0) = nan; % grouping values not in histogram interval are discarded
        gLabel{p} = num2strcell(his{p}(1:end-1));
    else     % simply replace group value by index
        [Idx{p}, gLabel{p}] = gidx(G{p});
    end
    nGroup(p) = length(gLabel{p});
    if nGroup(p) ==0
        error('grouping variable #%d has no level',p);
    end
end
%[Idx gnames] = cellfun(@grp2idx, G, 'Uniformoutput', false);
%ngroups = cellfun(@length, gnames);


% merge together grouping variables defined along same dimension
dimgroup = zeros(1,nDim);
Gdim = cell(1,nDim);
for d=1:nDim
    subg = find(dim==d &  ~dummypar);     %which (non-dummy)parameters are defined along that dim
    dimgroup(d) = prod(nGroup(subg)); %corresponding number of groups
    if length(subg) ==1 %one parameter for that dim
        Gdim{d} = Idx{subg};
    elseif length(subg) >= 2 %more than one param : group variables
        Gdim{d} = sub2ind(nGroup(subg), Idx{subg});
    end
end
dim2 = unique(dim);  %dim2 : uniques values of 'dim'
dimgroup = dimgroup(dim2); %keep only for grouping dimensions
%dimgroup(dimgroup==1) = [];  %keep only for grouping dimensions

%create cell array for index of elements in C
Idx = cell(1,nDim);
for d=1:nDim
    Idx{d} = 1:size(X,d);
end

%create output cell
nlevels = prod(dimgroup);
nElement = nlevels*nDummy; % number of elements
C = cell(nElement,1);
FF = ffact(dimgroup); %all combination of no-dummy parameters (merged within each dimension)
%!! should replace fullfact when one dimgroup is null and remove error message above when this happens (ngroup(p)==0)

%make grouping
if withdummy
    for i=1:nlevels
        vec =  (Gdim{dim2} == FF(i,1));  %change index in relevant dimensions only
        for e=1:nDummy
            idx = idummy(e) + find(vec(idummy(e) + ilist ));
            C{ i+e*(nlevels-1)} = X(idx);
        end
    end


else
    for i=1:nlevels
        for d=1:length(dim2)
            Idx{dim2(d)} =  (Gdim{dim2(d)} == FF(i,d));  %change index in relevant dimensions only
        end
        C{i} = X(Idx{:});
    end
end

%% give the output cell the required ndim shape
if ~isscalar(nGroup)
    [~, iSort] = sort(dim);   %isort : how each 'dim' value is mapped onto 'dim2' unique vector
    C = reshape(C, nGroup(iSort));
    if ~all(iSort== 1:nPar)
        C = ipermute(C, iSort);
    end
end

%% if minimal size is required
if ~isempty(maxValue)

    if length(maxValue)==1
        maxValue = repmat(maxValue, 1, nPar);
    elseif length(maxValue)~=nPar
        error('length of MAXVALUE should either be 1 or equal to the number of grouping variables');
    end

    findmax = (maxValue==-1);
    maxValue(findmax) = cellfun(@(x) str2double(x{end}), gLabel(findmax));

    %size of output argument
    siz = zeros(1,nPar);
    gpos = cell(1, nPar);
    for g = 1:nPar
        if maxValue(g)~=0
            gpos{g} = str2double(gLabel{g}); %convert to numeric
            assert( ~any(isnan(gpos{g})),'maximum value can be used only if grouping variable uses valid scalar values');
            if any(gpos{g}<1) || any(mod(gpos{g},1))
                error('maximum value can be used only if grouping variable uses positive integer values');
            end
            assert( max(gpos{g}) <= maxValue(g), 'maximum value in G larger than fixed largest value %d', maxValue(g));
            siz(g) = maxValue(g);
            gLabel{g} = cellfun(@num2str, num2cell(1:maxValue(g)), 'UniformOutput', false);

        else
            siz(g) = length(gLabel{g});
            gpos{g} = 1:siz(g);
        end
    end

    %create output argument
    if length(siz) > 1
        CC = cell(siz);
    else
        CC = cell(1,siz);
    end

    % empty cells must have appropriate size
    siz0= size(X);
    siz0(dim2) = 0;
    for i = 1:prod(siz)
        CC{i} = zeros(siz0);
    end

    %apply function(s) and assign to appropriate indices
    CC(gpos{:}) = C;
    C = CC;
end
end

% grp2idx
function [G, N] = gidx(X)
if exist('grp2idx') ==2 % use stats toolbox if possible
    [G, N] = grp2idx(X);
else
    U = unique(X); % all values in X
    U(isnan(U)) = []; % exclude nans
    G = size(X);
    N = cell(1,length(U));
    for i=1:length(U)
        G(X==U(i)) = i;
        N{i} = num2str(U(i));
    end
end

end

% fullfact
function D = ffact(L)
if exist('fullfact') ==2 % use stats toolbox if possible
    D = fullfact(L);
else
    D = cell(1,length(L));
    [D{:}] = ind2sub(L, 1:prod(L));
    D = cat(1,D{:})';
end
end