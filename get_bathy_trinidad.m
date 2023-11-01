% load GMRT data (save as coards compliant Netcdf for easier use
%
% This code is created to make a file similare to what Dan Rudnick used
% for the CalCOFI lines.  The data was downloaded from the GMRT data and
% used the COARDS compliant NetCDF data files which were better for the
% usage planned than the other NetCDF file option.
% FLB Oct. 25, 2023
lat=ncread('GMRTv4_1_1_20231011topo.nc','lat');
lon=ncread('GMRTv4_1_1_20231011topo.nc','lon');
depth=ncread('GMRTv4_1_1_20231011topo.nc','altitude');
dlat=abs(lat-41.05);
[~,ind]=min(dlat);
newlat=lat(ind);
depth=depth(:,ind);
m=length(lon);
clear lat;
%lat=repmat(newlat,m,1);
load anncycTr.mat;
anomlat=A.lat;
anomlon=A.lon;
newz=interp1(lon,depth,anomlon);
clear lat; clear lon;
lat=anomlat;
lon=anomlon;
[adist,offset]=calcdistfromshoreCRM(lon,lat,'Trin');
clear depth;
depth=newz;
dist=adist;
topo=depth;
topo(end)=depth(end-1);
topo=-1*topo;
save topoTr.mat topo dist;
%save trin_bathy.mat lat lon depth;
