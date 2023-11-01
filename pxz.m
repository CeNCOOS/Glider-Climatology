function [c1,h1,c2,h2] = pxz(mapstruct,var1str,var2str,itime,cont1,cont2,cont2h)

% Plot sections for the input parameters:
    % 'mapstruct':  'map','avmap', or 'anommap'
    % 'var1str':    variable to be plotted with a color contour
    % 'var2str':    variable to be plotted with a black contour
    % 'itime':      time indices to average over to make plot
    % 'cont1':      contour vector for var1 (if null, then matlab decides
    %               contour levels)
    % 'cont2':      contour vector for var2 (if null, then matlab decides
    %               contour levels)
    % 'cont2h':     heavy/labeled contour vector for var2 (if null, no
    %               heavy contours)
% 
%
% K.Zaba: Jun15,2016
% D. Rudnick, July 29, 2016
% plot distance vs depth
% modified to use glider ancillary variables.
% FLB Oct 25 2023

% Data
x = mapstruct.dist;
if isvector(mapstruct.depth)
    z = mapstruct.depth;
    ylim = [0 mapstruct.depth(end)];
    ylab='Depth (m)';
else
    z = mapstruct.sigma;
    ylim = [mapstruct.sigma(1) mapstruct.sigma(end)];
    ylab='Potential Density (kg/m^3)';
end

if ndims(mapstruct.(var1str)) == 3
   var1 = nanmean(mapstruct.(var1str)(:,:,itime),3); %#ok<NANMEAN> 
   if ut2dn(mapstruct.time(end))-ut2dn(mapstruct.time(1)) < 366
      dnfmt='mm/dd';
   else
      dnfmt='yyyy/mm/dd';
   end
   if isscalar(itime)
      dnstr = char(ut2ds(mapstruct.time(itime),dnfmt));
   elseif ndims(mapstruct.(var1str)) == 3
      dnstr=[char(ut2ds(mapstruct.time(itime(1)),dnfmt)) ' - ' char(ut2ds(mapstruct.time(itime(end)),dnfmt))];
   end
else
   var1=mapstruct.(var1str);
   dnstr='Mean';
end
titl=['Line ' mapstruct.line ', ' dnstr];

% Plot 
[c1,h1] = contourf(x,z,var1,cont1,'linestyle','none');
if isempty(cont1)
   set(h1,'levellistmode','auto');
   cont1=get(h1,'levellist');
   dc=cont1(end)-cont1(end-1);
   if strcmp(var1str,'geov') || (isfield(mapstruct,'isanom') && mapstruct.isanom)
      if abs(cont1(end)) > abs(cont1(1))
         cont1=-cont1(end):dc/2:cont1(end)+eps;
      else
         cont1=cont1(2)-dc:dc/2:-cont1(2)+dc+eps;
      end
   else
      cont1=cont1(2)-dc:dc/2:cont1(end)+dc+eps;
   end
   clf('reset');
   [c1,h1] = contourf(x,z,var1,cont1,'linestyle','none');
end

hold on;

if ~isempty(var2str)
   if ndims(mapstruct.(var2str)) == 3
      var2 = nanmean(mapstruct.(var2str)(:,:,itime),3); %#ok<NANMEAN> 
   else
      var2=mapstruct.(var2str);
   end
   cont2(ismember(cont2,cont2h)) = [];     % contour levels
   [c2,h2] = contour(x,z,var2,cont2,'k');
   [ch,hh] = contour(x,z,var2,cont2h,'k','linewidth',2);
   clabel(ch,hh);
   if isempty(cont2)
      set(h2,'levellistmode','auto');
   end
end

set(gca,'xdir','rev','ydir','rev',...
    'xlim',[min(x) max(x)],'ylim',ylim,'clim',[cont1(1) cont1(end)]);
xlabel('Offshore Distance (km)')
ylabel(ylab)
title(titl)
%keyboard;
% Plot Bathymetry
if isvector(mapstruct.depth)
   topo=load(['topo' mapstruct.line(1:2)]);
   area(topo.dist,topo.topo,'basevalue',ylim(2),'facecolor','k');
end

extlab = var1str;
if strcmp(var1str,'t')
   extlab = 'Temperature (\circC)';
   colormap(jet(64));
elseif strcmp(var1str,'s')
   extlab = 'Salinity (psu)';
   colormap(jet(64));
% New code
elseif strcmp(var1str,'ox')
	extlab='Dissolved Oxygen';
	colormap(jet(64));
elseif strcmp(var1str,'fl')
	extlab='Fluorescence';
	colormap(jet(64));
elseif strcmp(var1str,'cdom')
	extlab='CDOM Colored Dissolved Organic Matter';
	colormap(jet(64));
elseif strcmp(var1str,'bb')
	extlab='bb';
	colormap(jet(64));
% end of New code
elseif strcmp(var1str,'geov')
   extlab='Geostrophic Velocity (m/s)';
   colormap(redblue(length(cont1)-1));
elseif strcmp(var1str,'theta')
   extlab='Potential Temperature (\circC)';
   colormap(jet(64));
elseif strcmp(var1str,'sigma')
   extlab='Potential Density (kg/m^3)';
   flipud(colormap(jet(64)));
elseif strcmp(var1str,'depth')
   extlab='Depth (m)';
   colormap(jet(64));
end
if (isfield(mapstruct,'isanom') && mapstruct.isanom)
      colormap(redblue(length(cont1)-1));
      extlab=['Anomaly of ' extlab];
end
extbar('v',cont1,extlab)

hold off;

end