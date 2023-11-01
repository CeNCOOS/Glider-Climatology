function [mapnomean,meanmap]=demeanmap(map)
% function avmapnomean=demeanmap(avmap)
% Takes out the temporal mean of variables in map.
% Does the job by direct averaging.
%
% D. Rudnick, July 28, 2016

%Initialize
mapnomean=map;
mapnomean.isanom=true;
ntime=length(map.time);

meanmap=map;
meanmap=rmfield(meanmap,'time');

%Do it
vars=fieldnames(map);
for k=1:length(vars)
   d=size(map.(vars{k}));
   if d(end) == ntime
      meanmap.(vars{k})=nanmean(map.(vars{k}),length(d)); %#ok<NANMEAN> 
      mapnomean.(vars{k})=map.(vars{k})-repmat(meanmap.(vars{k}),[ones(1,length(d)-1),ntime]);
   end
end
