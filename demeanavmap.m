function avmapnomean=demeanavmap(avmap,meanmap)
% function avmapnomean=demeanavmap(avmap,meanmap)
% Takes out the temporal mean of variables in avmap by subracting the value
% in meanmap.
%
% D. Rudnick, July 28, 2016

%Initialize
avmapnomean=avmap;
avmapnomean.isanom=true;
ntime=length(avmap.time);

%Do it
vars=fieldnames(avmap);
for k=1:length(vars)
   d=size(avmap.(vars{k}));
   if d(end) == ntime
      avmapnomean.(vars{k})=avmap.(vars{k})-repmat(meanmap.(vars{k}),[ones(1,length(d)-1),ntime]);
   end
end

