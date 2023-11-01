function geov = computeGeoV(mapstruct)

% Compute the geostrophic velocity field and add it to the map structure.
% Input parameters:
    % 'mapstruct':  'map' or 'avmap'
%
%
% K.Zaba: Jun16,2016
% This computes the geostrophic velocity.  Note that since we didn't keep 
% the depth integrated velocity for all the deployments (need to reprocess)
% the ualong vlues has been commented out and the line before the end has a
% section that needs to be uncommented once the values are available.
% FLB Oct. 25 2023

% Constants
g = 9.81;       % gravity, m/s^2
rho0 = 1027;    % reference density, kg/m^3

[nz,nx,nsecs] = size(mapstruct.rho);

% dx = 1000*config.dx;                % horizontal spacing, m
dx = 1000*(mapstruct.dist(2)-mapstruct.dist(1));    % horizontal spacing, m
dz = 10;                                            % vertical spacing, m

f0 = ones(nz,1)*sw_f(mapstruct.lat)';               % Coriolis factor, 1/s
% we don't have this value so commenting out
%ualong = mapstruct.ualong;                          % along-shore velocity
rho    = mapstruct.rho;                             % density
geov   = nan(nz,nx,nsecs);                          % absolute geostrophic velocity

for iisec=1:nsecs
    [rhox,~] = gradient(rho(:,:,iisec),dx,dz);      % density gradients
    dvdz = -(g/rho0).*rhox./f0;                     % geostrophic shear
    vshear = cumsum(dvdz,1)*dz;                     % integral of geostrophic shear
    % Note we don't have the ualong vector for most of the Trinidad files
    % so we are going without for now.  
    geov(:,:,iisec) = vshear - ones(nz,1)*nanmean(vshear); %#ok<NANMEAN> %+ ones(nz,1)*ualong(:,iisec)'; %#ok<NANMEAN> 
end

