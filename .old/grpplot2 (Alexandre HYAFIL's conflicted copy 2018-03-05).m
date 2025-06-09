function varargout = grpplot2(varargin)
%grpplot(X, Y, G)
%grpplot(X, Y, G, 'obj', {objvalue1 objvalue2 ...})
%
%or directly grpplot({X1 X2 ...}, {Y1 Y2 ...}, 'obj', {objvalue1
%objvalue2...})
% for color, linewidth, markersize and marker, value can also be 'rgbk', [1 2] or 's*' 
%
%grpplot(X, Y, G, gnames, ...) to use specific group names
%
%handle = grpplot(...)
%
%See also grpplot, gscatter, grpn, grpmeann, colorplot
%
%works also for multidim group


%almost like grpplot and gscatter ->delete ?

if isempty(varargin{1})
    varargout = {[]};
    return;
end

if iscell(varargin{1})  %grpplot({X1 X2...}, {Y1 Y1 ...}, ...) syntax
    XG = varargin{1};
    YG = varargin{2};
    nG = length(XG);
    gnames = {};
    varargin = varargin(3:end);
else                     %grpplot(X, Y, G, ...) syntax
    X = varargin{1};
    Y = varargin{2};
    G = varargin{3};
    
    if isvector(X)
        X = X(:)';
    end
    if isvector(Y)
        Y = Y(:)';
    end
    
    %group X and Y by values
    [XG, gnames] = grpn(X,G);
    gnames = gnames{1};
    Gdim = size(XG);
    nG = numel(XG);
    YG = grpn(Y,G);
    varargin = varargin(4:end);
end

if length(varargin)>=1 && iscell(varargin{1})  %grpplot(X, Y, G, gnames, ...)
    gnames = varargin{1};
    varargin(1) = [];
end

%by default : one color for each group
if length(varargin)<2
  %  varargin = [varargin {'color', {'b', 'r', 'g', 'k', 'm', 'c','y'}}];
        varargin = [varargin {'color', defcolor}];
end

%position of object properties values
if mod(length(varargin),2) == 1  %plot(X, Y, '*', prop, propvalue, ...) syntax
    valpos = 3:2:length(varargin);
else %plot(X, Y, prop, propvalue, ...) syntax
    valpos = 2:2:length(varargin);
end

% convert string into cells
for v = valpos 
        if any(strcmpi(varargin{v-1},  {'marker','markersize','linewidth','color'})) ...
                && ~iscell(varargin{v}) && length(varargin{v})>1  %take corresponding value when object value is a cell
            varargin{v} = num2cell(varargin{v});    
        end
    end


% check size of cell values for multiple grouping variables
if length(Gdim)>2 || Gdim(2)>1 % if more than one grouping variable
    for v = valpos 
        if iscell(varargin{v})  %take corresponding value when object value is a cell
            if ~all( (size(varargin{v})== Gdim) | (size(varargin{v})== 1))
               error('dimension of cell array for argument ''%s'' should be singleton or match number of values in corresponding grouping variable',varargin{v-1}); 
            end
            varargin{v} = repmat(varargin{v}, Gdim ./ size(varargin{v}));    
        end
    end
end



%is the plot on hold
ish = ishold;
hold on;

handle = zeros(Gdim);

%plot each group separately
for g = 1:nG    
    
    if ~isempty(XG{g})
    
    %set specific options
    this_varg = varargin;
    for v = valpos
        if iscell(this_varg{v})  %take corresponding value when object value is a cell
            this_varg{v} = this_varg{v}{g};
        end
    end
    
    %plot
    handle(g) = plot(XG{g},YG{g},'linestyle','none',this_varg{:});
    
    else
       handle(g) = nan; 
    end
end

%add legend
if ~isempty(gnames)
    legend(gnames);
end

%turn hold off
if ~ish
    hold off;
end

if nargout > 0
   varargout = {handle}; 
end