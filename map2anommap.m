function anommap = map2anommap(anommap,avmap,map)

% Computes derived 'anommap' fields from 'avmap' & 'map' and puts them in
% the 'anommap' structure.
%
% K.Zaba; Aug8,2016

anommap.isanom = true;

iiav = 1:10:length(avmap.time);
nrep = length(map.time)/length(avmap.time(iiav));
%vars = {'ualong','uacross','theta','rho','sigma','geov'}; % original
vars = {'theta','rho','sigma','geov'};
for k=1:length(vars)
    var0 = vars{k};
    d = size(map.(var0));
    if length(d)==2
        anommap.(var0) = map.(var0)-repmat(avmap.(var0)(:,iiav),[1,nrep]);
    elseif length(d)==3
        anommap.(var0) = map.(var0)-repmat(avmap.(var0)(:,:,iiav),[1,1,nrep]);
    end
end
