function varargout = grpfun(varargin)
% deprecated - use gfun

warning('grpfun is deprecated, use gfun instead');
varargout = cell(1,max(1,nargout));
[varargout{:}] = gfun(varargin{:});
end