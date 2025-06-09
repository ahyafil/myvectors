function varargout = grphist(varargin)
% deprecated - use ghist

warning('grphist is deprecated, use ghist instead');
varargout = cell(1,max(1,nargout));
[varargout{:}] = ghist(varargin{:});
end