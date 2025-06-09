function varargout = grpmeann(varargin)
% deprecated - use gmean

warning('grpmeann is deprecated, use gmean instead');
varargout = cell(1,max(1,nargout));
[varargout{:}] = gmean(varargin{:});

end