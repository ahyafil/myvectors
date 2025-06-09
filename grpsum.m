function varargout = grpsum(varargin)
% deprecated - use gsum

warning('grpsum is deprecated, use gsum instead');
varargout = cell(1,max(1,nargout));
[varargout{:}] = gsum(varargin{:});

end