%Z = gfun(fun, Y, G)
%
%Z = gfun(fun, Y, G, subset)
%
%[Z1 Z2 .. Zn ] = gfun({fun1 fun2 ..funn}, Y, G)
%[Z1 Z2 .. Zn ] = gfun({fun1 fun2 ..funn}, Y, G, 'nargout', N)
%
%Z = gfun(fun, Y, G, 'max', M)
%(use 0 to ignore at that position)
%(use -1 to use max(X{i}) )
%
%gfun(..., plotopt) to use plot options as in function wu (type 'help wu'
%for more information)
%gfun(.... 'plotfunc', [i_raw i_error]) to use output i_raw for plotting
%raw values, and i_error for error values (default: 1st for raw and 2nd for
%error)
%gfun(..., 'gnames', Gn) where Gn is a cell array of group names to add
%labels/values to non-grouping dimensions for plotting
%
%
%Z = gfun(fun, Y, G, 'UniformOutput', bool)
%Z = gfun(..., 'multidim', method) to use a specific method when there are multiple grouping dimensions :
%- 'direct'    : nothing special (default)
%- 'merge' : data is merged across all grouping dimensions before applying the function
%- 'recursive' : apply the same functions recursively across all grouping dimensions
%
%gfun(...,'quantile', Q) to bin G data (see quantiles for more), Q being
%a vector or cell array of vectors (use empty to xxx)
%gfun(..., 'histc', edges) replaces G data with bin number in which each
%element falls (warning : unlike in function histc, values matching the
%upper boundary are added to last bin)
%
%[Z1 Z2 ... Zn gnames ] = ....
%gnames is cell array of group names
%
%See also GPRN, GMEAN, GSUM, GCOUNT, WU

%add 'simultaneous' for multi-dim, instead of recursive (would work for
%std/ste) : merge dimensions and apply on it


function varargout = gfun(fun, Y, G, varargin)

%% default values
subset = [];
maxvalue = [];
quants = [];
his = [];
uniformoutput = 1;
nout = [];
dim = [];
gnames2 = {};
multidim = 'direct';  %how to apply the function when there are multiple groupind dimensions : 'merge', 'recursive' or 'direct'

%default plot options values
%default values
doplot = 0;
plotopt = {};
plottype = 'line';
plotfun = [];
%errtype = '';

% %look in arguments ...
% etypes = {'noerror', 'std', 'sem'}; %... for error type
% for t=1:length(etypes),
%     isarg = cellfun(@(x) isequal(x,etypes{t}), varargin(3:end));
%     if any(isarg),
%         errtype = etypes{t};
%         varargin(find(isarg)+2) = []; %remove this parameter from list of arguments
%     end
% end


%% process arguments
if ~iscell(fun)
    fun = {fun};
end
nfun = length(fun);

%processing of parameters
if nargin >=4
    %subset
    if isnumeric(varargin{1}) || islogical(varargin{1})
        subset = varargin{1};
        v = 2;
    else
        v = 1;
    end
    
    %other parameters
    while v+3 <= nargin
        switch class(varargin{v})
            case 'char'
                
                
                switch lower(varargin{v})
                    case 'max'
                        v = v+1;
                        maxvalue = varargin{v};
                    case {'dim', 'dimension'}
                        v = v+1;
                        dim = varargin{v};
                    case {'quantile', 'quantiles'}
                        v = v+1;
                        quants = varargin{v};
                   case 'histc'
                        v = v+1;
                        his = varargin{v};
                    case 'uniformoutput'
                        v = v+1;
                        uniformoutput = varargin{v};
                    case 'nargout'
                        v = v+1;
                        nout = varargin{v};
                    case {'levels','gnames'}
                        v = v+1;
                        gnames2 = varargin{v};
                    case 'multidim'
                        v = v+1;
                        multidim = varargin{v};
                    case 'plot'
                        doplot = 1;
                    case 'plotfun'
                        %  doplot = 1;
                        v = v + 1;
                        plotfun = varargin{v};
                    case {'color', 'curve','linewidth', 'linestyle', 'marker', 'markersize',...
                            'facecolor','verticallabel',...
                            'barwidth', 'errorbarwidth','ticklength','errorstyle', 'title', 'name', 'xtick',...
                            'permute','collapse','axis','xtickrotate','ylabel','legend'}
                        doplot = 1;
                        plotopt(end+1:end+2) = varargin(v:v+1);  %add to plot options
                        v = v+1;
                    case {'line', 'bar', 'noplot', 'imagesc'}
                        doplot = 1;
                        plottype = varargin{v};
                    case {'var', 'variable', 'vars', 'varname', 'varnames', 'variables'}
                        doplot = 1;
                        v = v+1;
                        plotopt{end+1} = varargin{v};
                    otherwise
                        error('unknown parameter: %s',varargin{v});
                end
                
            case 'cell'
                plotopt{end+1} = varargin{v};   %variable names or group names
                
            otherwise
                error('gfun:unsupportedparameter', 'unsupported parameter type for parameter #%d',v+3);
        end
        
        v = v+1;
    end
    
end

if ~iscell(multidim)
    multidim = repmat({multidim}, nfun);
end


%% group data
if length(uniformoutput)==1 %one value per function
    uniformoutput = repmat(uniformoutput,1,nfun);
end

%group data
[Z, gnames, dim] = grpn(Y, G, subset, dim, maxvalue, quants, his);

%number of output argument for each function
if isempty(nout)
    if length(fun) ==1
        nout =  max( nargout-2 , 1 );
    else
        nout = ones(1,nfun);
    end
end
iout = [0 cumsum(nout)];

V = cell(1,iout(end));

%permutation of output cell
if ~isvector(Y)
    dim2 = unique(dim);
    %newdim = length(dim)-length(dim2); %number of dimensions to add to output matrix/cell
    ndim = ndims(Y);
    PermOrder =[];
  %  PermOrder = 1:ndim;
    for d = 1:length(dim2)
        thisd = find(dim==dim2(d));
        
        %first parameter along that dimension goes onto that dimension
      %  firstd = thisd(1);
        PermOrder(end+1)=dim2(d); %firstd;
       % PermOrder(firstd) = dim2(d);
       % PermOrder(dim2(d)) = firstd;
        
        %other parameters go as extra dimensions
        ExtraDim = thisd(2:end);
        nExtraDim = length(ExtraDim);
        %!!! commented in 2021, not sure why
      %  PermOrder(end+(1:nExtraDim)) = PermOrder(ExtraDim);
      %  PermOrder(ExtraDim) = ndim + (1:nExtraDim);
        PermOrder = [PermOrder ndim + (1:nExtraDim)];
        ndim = ndim + nExtraDim;
    end
    % add non-grouping dimensions
    PermOrder = [PermOrder setdiff(1:ndims(Y),dim2)];
    
else   %if Y is a vector, do not permute
    PermOrder = 1:ndims(Z);
end


%% apply function(s) to each cell element
for v=1:nfun
    
    w = iout(v)+1:iout(v+1); %output argument indices
    
    
    %look for  'dim' flag
    fstr = func2str(fun{v});
   % dimpos = strfind(fstr, '''dim''');
    
   % if ~isempty(dimpos) %with flag
    if any(regexp(fstr, '''dim''')) %with flag
        
        dim2 = unique(dim);
        if length(dim2)>1 %when there are multiple grouping dimensions
            switch multidim{v}
                case 'direct'
                    fstrrep = strrep(fstr, '''dim''', mat2str(dim2));  %replace the 'dim' tag with actual dimensions
                    func = str2func(fstrrep);
                    [V{w}] = cellfun(func, Z, 'UniformOutput', false);   %apply function
                    
                case 'recursive'
                    V{w} = Z;
                    for d=1:length(dim2) %recursively for all dimensions
                        fstrrep = strrep(fstr, '''dim''', num2str(dim2(d))); %replace the 'dim' tag with actual dimension
                        func = str2func(fstrrep);
                        [V{w}] = cellfun(func, V{w}, 'UniformOutput', false);   %apply function
                    end
                    
                case 'merge'
                    if ~any(strcmp(multidim(1:v-1),'merge')) %unless already computed for previous function ...
                        Z2 = cellfun(@(x) mergedim(x, dim2), Z, 'UniformOutput', false);                  % ... merge all dimensions of 'dim' in each cell
                    end
                    fstrrep = strrep(fstr, '''dim''', num2str(dim2(1)));
                    func = str2func(fstrrep);
                    [V{w}] = cellfun(func, Z2, 'UniformOutput', false);   %apply function
                    
                otherwise
                    error('invalid method for multidim option : ''%s''', multidim{v});
            end
        else
            fstrrep = strrep(fstr, '''dim''', num2str(dim2));
            func = str2func(fstrrep);
            [V{w}] = cellfun(func,Z, 'UniformOutput', false);   %apply function
        end
        
        
    else  %no flag
        [V{w}] = cellfun(fun{v}, Z, 'UniformOutput', false);   %apply function
        
    end
    
    %% convert to numerical array if uniformoutput
    for ww=w
        V{ww} = ipermute(V{ww}, PermOrder);
        if uniformoutput(v)
            if isempty(V{ww}) || ~iscell(V{ww}{1})
            V{ww} = cell2mat(V{ww});  %convert to mat
            else  
                %unless if cell (since cell2mat is not supported)
                for d=1:dim2
                   V{ww} = catcell(d, V{ww}, d);  %concatenate along dim2 dimensions
                end
                V{ww} = V{ww}{1};
            end
        end
    end
    
end

%gnames2 is same as gnames but also with gnames for non-grouped dimensions
if isvector(Y)
    gnames2 = gnames;
else
    gnames3 = cell(1,ndim);
    
    
    gdim = PermOrder(1:length(dim)); %for grouped dimensions
    gnames3(gdim) = gnames;
    
    nongdim = setdiff( 1:ndim , gdim);  %for non grouped dimensions
    if ~isempty(gnames2)
        gnames3(nongdim) = gnames2;  %pre-specified values
    end
    for d = nongdim
        if isempty(gnames3{d})  %if not pre-specified
            ng =  num2cell( 1:size(V{1},d) );
            gnames3{d} = cellfun(@num2str, ng, 'UniformOutput', false);
        elseif ~iscell(gnames3{d})
            gnames3{d} = num2cell( gnames3{d}(:) );
            gnames3{d} = cellfun(@num2str, gnames3{d}, 'UniformOutput', false);
        end
    end
    gnames2 = gnames3;
end


varargout = [V {gnames gnames2} ];

%% plot
if doplot
    if isempty(plotfun)
        plotfun = 1:min(2,nout);
    end
    
    switch length(plotfun)  %plot only raw or raw and error values
        case 1
            [~, ~, plothandle] = wu(V{plotfun(1)}, [], gnames2, plottype, plotopt{:});   %if only one output : no error bar
            
        case 2
            [~, ~, plothandle] = wu(V{plotfun}, gnames2, plottype, plotopt{:});   %with error bar
        otherwise
            error('gfun: can plot only if no more than two output matrices');
    end
      varargout{end+1} = plothandle;
    %else
    %    varargout(end-1) = [];
end


end