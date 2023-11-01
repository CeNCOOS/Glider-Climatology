function mapmask=topomask(map)
% function mapmask=topomask(map)
% mask map using topo
%
% D. Rudnick, July 30, 2016
% Apply a topographic mask to data.
% Modified to handle the input file created for Trinidad.
% May need to be modified for other glider lines.
% FLB Oct 25, 2023

%Initialize
ndepth=length(map.depth);
ndist=length(map.dist);
if isfield(map,'time')
   ntime=length(map.time);
else
   ntime=1;
end
mapmask=map;

%Load topo
%keyboard;
% we don't have to top files so we need to figure out what to do here
topo=load(['topo' map.line(1:2)]);
dd=map.dist(2)-map.dist(1); %#ok<NASGU> 
topomap=topo.topo; % new code
%topomap=topo.topo(1:dd:end); % original code
%keyboard;
%topomap=repmat(topomap,[ndepth 1]); % original code
topomap=repmat(topomap',51,1);
% FLB code here to replace the line below it
mask=0.*repmat(map.depth,[1 ndist]); %#ok<NASGU> 
%keyboard;
mask=topomap < repmat(map.depth,[1 ndist]);

mask=repmat(mask,[1 ntime]);

%Do it
vars=fieldnames(map);
%keyboard;
for k=1:length(vars)
   d=size(map.(vars{k}));
   if d(1) == ndepth && ~isvector(map.(vars{k}))
      mapmask.(vars{k})(logical(mask))=nan;
   end
end
