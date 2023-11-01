function bindata = calcualongacross(bindata,line)

% bindata = calcualongacross(bindata,line)
% Calculates along and across shore velocity given the line.

% adapted from calcdistfromshore
% D. Rudnick, 19 Oct 2012
% D. Rudnick, 16 May 2017 - added support for udop
%
% If we had the u and v data this code would be used.  
% As we were not consistent in outputing the u and v data this function was
% not used.  It will be need to be modified for the Trinidad line to load
% the appropriate data file and not the calcofilines.mat
% ****Need modification for Trinidad if it is to be used*****
% FLB Oct. 24, 2023

% Set parameters
matname = 'calcofilines.mat';
deg2min = 60;
deg2rad = pi/180;

% CalCOFI Station coordinates
load(matname,'calcofilines')
xsta = calcofilines.(line).lon;
ysta = calcofilines.(line).lat;
x0 = xsta(xsta == max(xsta)); % longitude of innermost station (zero point)
y0 = ysta(xsta == max(xsta)); % latitude of innermost station
x1 = xsta(xsta == min(xsta)); % longitude of outermost station
y1 = ysta(xsta == min(xsta)); % latitude of outermost station

% Calculate angle of section
dy = (y0-y1)*deg2min;
dx = cos(1/2*(y0+y1)*deg2rad)*(x0-x1)*deg2min;
ang0 = atan2(dy,dx); % orientation of line, radians north of east

% Calculate along and across shore velocity
w=(bindata.u+1i*bindata.v)*exp(-1i*ang0);
bindata.ualong=imag(w);
bindata.uacross=real(w);

%udop, if exists
if isfield(bindata,'udop')
   w=(bindata.udop+1i*bindata.vdop)*exp(-1i*ang0);
   bindata.udopalong=imag(w);
   bindata.udopacross=real(w);
end

