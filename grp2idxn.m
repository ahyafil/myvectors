%[idx, gnames] = grp2idxn(S)
%where S is matrix groups creating a single index for each combination of values of different rows
%
%[idx, gnames] = grp2idxn(S, gnames) to use pre-defined group names
%
%[idx, gnames] = grp2idxn(S, gnames, sep) or grp2idxn(S, [], sep) to
%concatenate group names using string sep as separator between all names
%(.e.g. grp2idxn(S, '_') )
%if cell array of string, use each string for separator between successiv
%names

function [idx, gnames] = grp2idxn(S, gnamep, sep)

%[nvar l] = size(S);
nvar = size(S,1);

if nargin ==1 || isempty(gnamep)
   gnamep = cell(1,nvar); 
end


%get index for each row separately
idv = cell(1,nvar);
gnamv = cell(1,nvar);
ng = zeros(1,nvar);
isnum = isnumeric(S) && all(cellfun(@isnumeric, gnamep));

for v=1:nvar
   [idv{v}, gnamv{v}] = grp2idx(S(v,:)); 
   ng(v) = length(gnamv{v});
   if ~isempty(gnamep{v})
       gnamv{v} = gnamep{v};
   end
end

%get single index
idx2 = sub2ind(ng, idv{:});

%keep only existing combinations
[idx, cbi] = grp2idx(idx2);
idx = idx';
cbi = cellfun(@str2num, cbi);

%corrsponding values of combinations
cbi2 = cell(1,nvar);
[cbi2{:}] = ind2sub(ng, cbi);

gnames = cell(nvar, length(cbi));
for v=1:nvar
    gnames(v,:) = gnamv{v}(cbi2{v});
end

%% final operations on group names
if nargin>=3 %concatenate using separator
    if ischar(sep)
       sep = repmat({sep}, 1, nvar-1);  %same separator for each separation
    end
    
    gnames2 = cell(nvar,1);
    gg = cell(1,2*nvar-1);
    for c=1:length(cbi)
        gg(1:2:2*nvar-1) = gnames(:,c); %all group names at uneven indices
        gg(2:2:2*nvar-2) = sep;         %separator at even indices (in between group names)
        gnames2{c} = cat(2,gg{:});           %concatenate into single group name
    end
    gnames = gnames2;
    
elseif isnum  %convert to numerical array
   gnames = cellfun(@str2num,gnames); 
end