function [dist, offset] = calcdistfromshoreCRM(x,y,linestr) %#ok<INUSD> 

% Calculates distance along CalCOFI line and gives offset from line.
% Converse of calcposalonglineCFM.m. 
% calcdistfromshore.m and calcdistfromshoreCRM.m differ by respective
% definitions of dist==0. In calcdistfromshore.m, dist==0 is defined by the
% location of the first CalCOFI station. In calcdistfromshoreCRM.m, dist==0
% is defined by the location of the shore (as computed from the CRM
% bathymetric data set). Inputs are x (longitude), y (latitude), and string
% line ('line66','line80','line90',etc.)
%
% K.Zaba, 12 March 2014

% This code has been modified to handle the Trinidad line.  The file
% trinidad_line.mat has a structure called calcofilines with an element
% Trinidad to meet the code requirements below.  Note also the inshore end
% has been manually added. We don't have access to Dan's original file but
% that wouldn't have helped as it would only have the CalCOFI line end
% points and not the Trinidad end points.  The code does what is says above
% subject to the modifications for the Trinidad line positions.
% This code is called by a few different functions.
% FLB Oct. 24, 2023

% Load Shore Position Data
% this file was not found so comment out FLB
%load 'shoreposition.mat'; %#ok<LOAD> 

% Set parameters
matname='trinidad_line.mat';
nm2km = 1.852;
deg2min = 60;
deg2rad = pi/180;

% CalCOFI Station coordinates
load(matname,'calcofilines'); % new file has internal array with this name.
linestr='Trin'; % my name for our test
xsta = calcofilines.(linestr).lon;
ysta = calcofilines.(linestr).lat;
% inshore end of line 66.7 but not the shore values
%x0=-121.99; % estimate for original
%y0=36.82; % estimate for original 
% below are for Trinidad line
x0=-124.1581;
y0=41.05;
% see above for comment outt these 2 lines
%x0 = shoreposition.(linestr).lon;   % longitude of shore
%y0 = shoreposition.(linestr).lat;   % latitude of shore
%keyboard;
x1 = xsta(xsta == min(xsta)); % longitude of outermost station
y1 = ysta(xsta == min(xsta)); % latitude of outermost station

% Calculate distance/angle to zero point
dy = (y1-y0)*deg2min;
dx = cos(1/2*(y1+y0)*deg2rad)*(x1-x0)*deg2min;
ang0 = atan2(dy,dx); % orientation of line, radians north of east 
dy = (y-y0)*deg2min;
dx = cos(1/2*(y+y0)*deg2rad).*(x-x0)*deg2min;
dist0 = sqrt(dy.^2+dx.^2)*nm2km;
ang = atan2(dy,dx);
theta = ang0-ang;   % angle between line and vector to profile point (+ if north of line)

% Calculate distance from shore to profile (project onto line)
dist = dist0.*cos(theta);   % distance from zero point along line
offset = dist0.*sin(theta); % perpendicular distance from line