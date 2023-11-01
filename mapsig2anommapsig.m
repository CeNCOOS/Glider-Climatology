function anommapsig = mapsig2anommapsig_woa(avmapsig,mapsig)

% Computes anomalies of isopycnal fields and puts them in structure
% 'anommapsig'.
% K.Zaba; Aug8,2016
% 
% Modifed to have all the ancillary variables.
% FLB Oct. 25, 2023

anommapsig.line  = mapsig.line;
anommapsig.sigma = mapsig.sigma;
anommapsig.dist  = mapsig.dist;
anommapsig.lat   = mapsig.lat;
anommapsig.lon   = mapsig.lon;
anommapsig.time  = mapsig.time;

iiav = 1:10:length(avmapsig.time);
nrep = length(mapsig.time)/length(avmapsig.time(iiav));
vars = {'depth','t','s','theta','rho','geov','fl','ox','cdom','bb'};
for k=1:length(vars)
   var0 = vars{k};
   if isfield(mapsig,var0)
      d = size(avmapsig.(var0));
      if length(d)==2
         anommapsig.(var0) = mapsig.(var0) - ...
            repmat(avmapsig.(var0)(:,iiav),[1,nrep]);
      elseif length(d)==3
         anommapsig.(var0) = mapsig.(var0) - ...
            repmat(avmapsig.(var0)(:,:,iiav),[1,1,nrep]);
      end
   end
end

anommapsig.isanom = true;

