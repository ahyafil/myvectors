function pos=minpos(varargin)
%positions of the elements that reach the minimum of the array

switch nargin
    case 1, [dem pos]=min(varargin{1});
    case 2, [dem pos]=min(varargin{1}, varargin{2});    
    case 3, [dem pos]=min(varargin{1}, varargin{2}, varargin{3}); 
end