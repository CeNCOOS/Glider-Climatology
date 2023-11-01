function mapstruct = addderivedvars(mapstruct)
%
% Computes derived fields (theta,rho,sigma,geov) and adds them to the map
% structure (mapstruct).
%
%
% K.Zaba: Jun14,2016
% D. Rudnick, July 28, 2016
%
% This function is called by a number of other functions.  The main output
% is to add the derived variables:
% theta (potential temperature)
% rho (density) - 1000
% sigma (potential density at a standard temperature at sfc - 1000
% geov (geostrophic velocity) Note test set did NOT all have the depth
% averaged u and v components so this was modified to not use those values.
% This is also way calcualongacross is commented out!
%
% Additional notes FLB Oct 24 2023
%

t = mapstruct.t;
s = mapstruct.s;
[nz,nx,nt] = size(t);

% Initialize derived fields
%mapstruct       = calcualongacross(mapstruct,['line' mapstruct.line(1:2)]);
%keyboard;
p               = sw_pres(mapstruct.depth*ones(1,nx), ...
                          ones(nz,1)*mapstruct.lat');       % pressure (db)
mapstruct.theta = nan(nz,nx,nt);
mapstruct.rho   = nan(nz,nx,nt);
mapstruct.sigma = nan(nz,nx,nt);
mapstruct.geov  = nan(nz,nx,nt);

% Loop through sections, compute derived fields: theta, rho, sigma
for iit=1:nt
    mapstruct.theta(:,:,iit) = sw_ptmp(s(:,:,iit),t(:,:,iit),p,0);
    mapstruct.rho(:,:,iit)   = sw_dens(s(:,:,iit),t(:,:,iit),p)-1000;
    mapstruct.sigma(:,:,iit) = sw_pden(s(:,:,iit),t(:,:,iit),p,0)-1000;
end

% Add GEOV computation
mapstruct.geov = computeGeoV(mapstruct);