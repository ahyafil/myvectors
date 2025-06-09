function pos = maxpos(varargin)
%position of the first element that reaches the maximum of the array
%same options as max

[~, pos] = max(varargin{:});

