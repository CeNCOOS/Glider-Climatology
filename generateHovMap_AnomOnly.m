function [out] = generateHovMap_AnomOnly(A,B,d,xx,tt,gauss,varargin)

% Generate objective map in hovmoller form. This script is an adaptation 
% and merger of Todd's scripts maphov.m and maphovdoy.m. Inputs are:
    % x: across-shore position
    % t: unixtime
    % d: detrended data, nans removed
    % x0: spatial grid of output map
    % t0: temporal grid of output map
    % gauss: 3 parameters of Gaussian covariance matrix
    % noise: noise-to-signal ratio
    % varargin: domse=true calculates the mean square errorl domse=false
        % does not calculate the mean square error and is much faster and
        % less memory intensive; if domse is not provided, the mean square
        % error is calculated by default
% 
% K.Zaba, May22,2014

% Parse Inputs
if isempty(varargin)
    domse = true;
else
    domse = varargin{1};
end

% Set up 2D grid for map
[m, n] = size(xx);
nmap = m*n; %#ok<NASGU> 
xx = xx(:); %#ok<NASGU> 
tt = tt(:); %#ok<NASGU> 

% make map and mse, if desired
C = A\d;
map = B*C;
out.data = reshape(map,m,n);
if domse
%    mse = diag(1-B*(A\B')/gauss(1)); % this step is very slow
   mse=1-sum(B'.*(A\B'))/gauss(1);
   out.mse = reshape(mse,m,n);
end