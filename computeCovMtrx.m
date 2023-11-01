function [A, B] = computeCovMtrx(x,t,xx,tt,gauss,noise)

% Compute covariance matricies. Outputs:
    % A: data covariance matrix
    % B: model-data covariance matrix
%
% K.Zaba, May22,2014
%
% This function is called by climatologyCCS_AnomOnly.m
% FLB Oct-25-2023

% Parameters
nmaxfac = 0.12;  % maximum fraction of nonzero elements in covariance matrices
covmin = 1e-3;
s2d = 1/86400; 

% 2D grid for map
[m, n] = size(xx);
nmap = m*n;
xx = xx(:);
tt = tt(:);

% construct data covariance matrix
npt = length(x);
nmax = round(nmaxfac*npt^2);
rows = zeros(nmax,1);
cols = zeros(nmax,1);
vals = zeros(nmax,1);
rows(1:npt) = 1:npt;
cols(1:npt) = 1:npt;
vals(1:npt) = noise;
ilast = npt;
for ipt = 1:npt % loop through obs points to directly construct sparse matrix
    r = x(ipt)-x(ipt:npt);
    s = (t(ipt)-t(ipt:npt))*s2d;
    dd = gauss(1)*exp(gauss(2)*r.^2+gauss(3)*s.^2); % covar of ipt with others
    ii = find(dd>=covmin);
    jj = ipt*ones(size(ii));
    dd = dd(ii);
    ii = ii+ipt-1;
    tmprows = [ii; jj(2:end)];
    tmpcols = [jj; ii(2:end)];
    tmpvals = [dd; dd(2:end)];
    nval = length(tmprows);
    rows(ilast+1:ilast+nval) = tmprows;
    cols(ilast+1:ilast+nval) = tmpcols;
    vals(ilast+1:ilast+nval) = tmpvals;
    ilast = ilast+nval;
    if ilast > nmax
        fprintf('Warning: preallocated matrix size exceeded at step %g\n',ipt)
    end
end
rows = rows(1:ilast);
cols = cols(1:ilast);
vals = vals(1:ilast);
A = sparse(rows,cols,vals,npt,npt);

% construct model-data covariance matrix
nmax = round(nmaxfac*npt*nmap);
rows = zeros(nmax,1);
cols = zeros(nmax,1);
vals = zeros(nmax,1);
ilast = 0;
for ipt = 1:nmap % loop through map points to directly construct sparse matrix
    r = xx(ipt)-x;
    s = (tt(ipt)-t)*s2d;
    dd = gauss(1)*exp(gauss(2)*r.^2+gauss(3)*s.^2); % covar of ipt with others
    ii = find(dd>=covmin);
    jj = ipt*ones(size(ii));
    dd = dd(ii);
    tmprows = jj;
    tmpcols = ii;
    tmpvals = dd;
    nval = length(tmprows);
    rows(ilast+1:ilast+nval) = tmprows;
    cols(ilast+1:ilast+nval) = tmpcols;
    vals(ilast+1:ilast+nval) = tmpvals;
    ilast = ilast+nval;
    if ilast > nmax
        fprintf('Warning: preallocated matrix size exceeded at step %g\n',ipt)
    end
end
rows = rows(1:ilast);
cols = cols(1:ilast);
vals = vals(1:ilast);
B = sparse(rows,cols,vals,nmap,npt);
clear rows cols vals