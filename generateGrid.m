function [x0,t0] = generateGrid(x,t,dx,dt,isdoy)

% Generate uniformly spaced spatial and temporal grids. If isdoy=true, 
% this code produces the map at the same dates for each year for easier 
% calculation of annual averages.
%
% requires dn2ut which converts from datenum to unix time
% requires ut2dn which converts unix time to datenum
% K.Zaba May22,2014
%
% As with all code dealing with time values need to make sure it is in the
% proper format as if it is in the wrong format the code will create
% nonsense.
% FLB Oct. 25, 2023

nx = length(x); %#ok<NASGU> 
nt = length(t);

[yystart,mmstart,~,~,~,~] = datevec(ut2dn(t(1)));
[yyend,mmend,~,~,~,~] = datevec(ut2dn(t(nt)));

% Set up grid for map
% Spatial Grid
xstart = 0;
xend = nanmax(x); %#ok<NANMAX> 
x0 = (xstart:dx:xend)';
% Temporal Grid
if isdoy
    tstart = yystart;   % first year to do
    tend = yyend;       % last year to do
    yeardays = 0:dt:365;
    nyd = length(yeardays);
    nyear = tend-tstart+1;
    year = repmat(tstart:tend,[nyd 1]);
    t0 = dn2ut(repmat(yeardays',[nyear 1])+datenum(year(:),1,1)); %#ok<DATNM> 
elseif ~isdoy
    tstart = dn2ut(datenum(yystart,mmstart,1)); %#ok<DATNM> % first date to do
    tend = dn2ut(datenum(yyend,mmend+1,1));     %#ok<DATNM> % last date to do
    t0=(tstart:(dt*86400):tend)'; % constant is seconds per day.
end