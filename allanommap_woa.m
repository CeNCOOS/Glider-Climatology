function [map,maptm,mapem,maptmem,mapsig,mapsigem,...
          anommap,anommaptm,anommapem,anommaptmem,anommapsig,anommapsigem] = allanommap_woa(lineID)

% Given line one of {'90.0','80.0','66.7'}, calculates derived fields and
% structures from the objectively mapped 'anommap' structure.
%
% K.Zaba; Aug5,2016

% Parameters
errthresh=0.3;
sigsig=25:0.1:27;

% Load 'config', 'anommap', 'avmap' structures
load(['map_' lineID(1:2) '_AnomOnly.mat']) %#ok<LOAD> 
load(['woa_anncyc' lineID(1:2) '.mat'],'avmap','avmapsig')

anommap.config = config;
%keyboard;
map     = anommap2map_woa(anommap,avmap);
map     = addderivedvars(map);
maptm   = topomask(map);
mapem   = errmask_woa(map,errthresh);
mapem   = datemask(mapem);
maptmem = errmask_woa(maptm,errthresh);
maptmem = datemask(maptmem);

anommap     = map2anommap(anommap,avmap,map);
anommaptm   = topomask(anommap);
anommapem   = errmask_woa(anommap,errthresh);
anommapem   = datemask(anommapem);
anommaptmem = errmask_woa(anommaptm,errthresh);
anommaptmem = datemask(anommaptmem);

mapsig   = interpmap_sigma(maptm,sigsig);
mapsigem = interpmap_sigma(maptmem,sigsig);

anommapsig   = mapsig2anommapsig(avmapsig,mapsig);
anommapsigem = mapsig2anommapsig(avmapsig,mapsigem);

