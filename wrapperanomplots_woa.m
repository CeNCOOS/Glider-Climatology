function wrapperanomplots_woa(lineID,monthback,basepath)

% Makes all 'map' and 'anommap' plots;
% Arguments line {'90.0','80.0','66.7'} and basepath base directory.
% Writes all plots in an organized directory tree.
%
% K.Zaba; Aug9,2016
% D.Rudnick; Sep5,2018 - added monthback
% No modifications.  Just need to make sure that the files have the
% appropriate names (for Trinidad it will be mapTr.mat instead of
% map66.mat')
% FLB Oct. 25, 2023

%Parameters
xzrng = [addtodate(now,-monthback,'month') now]; %#ok<DATOD,TNOW1> % date range for which to plot xz plots (meant for updates)

% Load map and anommap structures
load(['woa_map' lineID(1:2) '.mat'],'mapem','maptmem','mapsigem')
load(['woa_map' lineID(1:2) '.mat'],'anommapem','anommaptmem','anommapsigem')

ixz = find(xzrng(1)<=ut2dn(mapem.time) & ut2dn(mapem.time)<=xzrng(2)); % mapem time is not correct need to check what is up
%ixzkeyboard;
% 
makemapplots_woa(mapem,maptmem,ixz,basepath)

makemapsigplots_woa(mapsigem,ixz,basepath)

makeanommapplots_woa(anommapem,anommaptmem,ixz,basepath)

makeanommapsigplots_woa(anommapsigem,ixz,basepath)
