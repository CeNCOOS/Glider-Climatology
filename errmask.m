function mapmask=errmask(map,errthresh)

% Mask map using error mask
%
% K.Zaba; Aug8,2016
%
% This was updated to add the ancillary variables to the mask.
% Not sure if the second loop needs to have the other variables or not
% since it is about theta, rho and sigma...
% FLB Oct. 25, 2023

mapmask=map;

%vars = {'t','s','u','v','fl'}; % original
vars = {'t','s','fl','ox','cdom','bb','u','v'};
for k=1:length(vars)
   var0 = vars{k};
   if isfield(mapmask,var0)
      mask = mapmask.err.(var0)>errthresh;
      mapmask.(var0)(mask)=nan;
      if strcmp(var0,'u') && isfield(mapmask,'uacross')
         mapmask.uacross(mask) = nan;
      elseif strcmp(var0,'v') && isfield(mapmask,'ualong')
         mapmask.ualong(mask) = nan;
      end
   end
end
% Do we need to do this for ox, fl, cdom, and bb?
if isfield(mapmask,'t') && isfield(mapmask,'s')
   errts = max(mapmask.err.t,mapmask.err.s);
   varsder = {'theta','rho','sigma','geov'};
   for k=1:length(varsder)
      var0 = varsder{k};
      if isfield(mapmask,var0)
         mask = errts>errthresh;
         mapmask.(var0)(mask)=nan;
      end
   end
end
