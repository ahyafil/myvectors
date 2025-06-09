function varargout = grpplot2(varargin)
%grpplot(X, Y, G)
%grpplot(X, Y, G, 'obj', {objvalue1 objvalue2 ...})
%
%or directly grpplot({X1 X2 ...}, {Y1 Y2 ...}, 'obj', {objvalue1
%objvalue2...})
%
%grpplot(X, Y, G, gnames, ...) to use specific group names
%
%handle = grpplot(...)
%
%See also grpplot, gscatter, grpn, grpmeann, colorplot

%almost like grpplot and gscatter ->delete ?
%make for multidim group

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
    nG = length(gnames);
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

%is the plot on hold
ish = ishold;
hold on;

handle = zeros(1,nG);

%plot each group separately
for g = 1:nG
    
    %set specific options
    varg = varargin;
    for v = valpos
        if iscell(varg{v})  %take corresponding value when object value is a cell
            varg{v} = varg{v}{g};
        end
    end
    
    %plot
    handle(g) = plot(XG{g},YG{g},varg{:});
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