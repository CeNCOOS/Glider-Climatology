function map = anommap2map(anommap,avmap)

% Takes 'anommap' and 'avmap' structures to compute the total t, s, u, v 
% fields and puts them in 'map' structure.
%
% K.Zaba; Aug 5, 2016
%
% modified to have ancillary variables beyond what Dan had.
% The code just adds to a map structure.
% FLB Oct. 24 2023.

map.config = anommap.config;
map.line   = anommap.line;
map.depth  = anommap.depth;
map.dist   = anommap.dist;
map.lat    = anommap.lat;
map.lon    = anommap.lon;
map.time   = anommap.time;

iiav = 1:10:length(avmap.time);
nrep = length(map.time)/length(avmap.time(iiav));
%vars = {'t','s','u','v','fl'}; % original
vars = {'t','s','u','v','fl','ox','cdom','bb'}; % new may need to remove u,v
for k=1:length(vars)
   var0 = vars{k};
   if isfield(anommap,var0)
      d = size(anommap.(var0));
      if length(d)==2
         map.(var0) = anommap.(var0)+repmat(avmap.(var0)(:,iiav),[1,nrep]);
      elseif length(d)==3
         %keyboard;
         map.(var0) = anommap.(var0)+repmat(avmap.(var0)(:,:,iiav),[1,1,nrep]);
      end
      map.err.(var0) = anommap.err.(var0);
   end
end