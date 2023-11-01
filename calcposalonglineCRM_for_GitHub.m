function [lon, lat,x_innerouter, y_innerouter] = calcposalonglineCRM(dist,linenum) %#ok<INUSD> 

% Calculates position along CalCOFI line for input distance values.
% Converse of calcdistfromshoreCRM.m. 
%
% K.Zaba, May22,2014
%
% This code has been modified for the Trinidad line.  
% both the trinidad_line.mat and inshore end point are specific to the
% Trinidad line.  
% FLB Oct. 24, 2023
 
load 'trinidad_line.mat'; %#ok<LOAD> Trinidad
%linestr = ['line',linenum(1:2)]; original
linestr='Trin';
%x0=-121.99; % estimates for line 66.7
%y0=36.82; % estimate for line 66.7
% data for trinidad
x0=-124.1581;
y0=41.05;
nm2km = 1.852;
deg2min = 60;
deg2rad = pi/180;

xsta = calcofilines.(linestr).lon;
ysta = calcofilines.(linestr).lat;

%x0 = shoreposition.(linestr).lon;   % longitude of shore
%y0 = shoreposition.(linestr).lat;   % latitude of shore
x1 = xsta(xsta == min(xsta));       % longitude of outermost station
y1 = ysta(xsta == min(xsta));       % latitude of outermost station

x_innerouter = [x0 x1];
y_innerouter = [y0 y1]; 

% Calculate lon/lat position
dy = (y1-y0)*deg2min;                           % deg
dx = cos(1/2*(y1+y0)*deg2rad)*(x1-x0)*deg2min;  % deg
ang0 = atan2(dy,dx);                            % orientation of line, radians north of east
dist = dist/nm2km/deg2min;                      % deg

lat = dist*sin(ang0) + y0;
lon = dist*cos(ang0)./cos(1/2*(lat+y0)*deg2rad) + x0; 