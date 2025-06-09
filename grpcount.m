function varargout = grpcount(varargin)
% deprecated - use gfun

warning('grpcount is deprecated, use gcount instead');
varargout = cell(1,max(1,nargout));
[varargout{:}] = gcount(varargin{:});
end