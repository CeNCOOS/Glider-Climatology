function [c1,h1,c2,h2] = ptimez(mapstruct,var1str,var2str,ix,cont1,cont2,cont2h)

% Plot sections for the input parameters:
    % 'mapstruct':  'map','avmap', or 'anommap'
    % 'var1str':    variable to be plotted with a color contour
    % 'var2str':    variable to be plotted with a black contour
    % 'ix':         distance indices to average over to make plot
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
% 
% This code plots vs depth.  Added the ancillary glider variables.
% FLB Oct. 25, 2023
%

% Data
dn = ut2dn(mapstruct.time);
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

var1 = squeeze(nanmean(mapstruct.(var1str)(:,ix,:),2)); %#ok<NANMEAN> 
if isscalar(ix)
   dnstr = [num2str(x(ix)) ' km'];
else
   dnstr=[num2str(x(ix(1))) ' - ' num2str(x(ix(end))) ' km'];
end
titl=['Line ' mapstruct.line ', ' dnstr];

% Plot 
[c1,h1] = contourf(dn,z,var1,cont1,'linestyle','none');
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
   [c1,h1] = contourf(dn,z,var1,cont1,'linestyle','none');
end

hold on;

if ~isempty(var2str)
   var2 = squeeze(nanmean(mapstruct.(var2str)(:,ix,:),2)); %#ok<NANMEAN> 
   cont2(ismember(cont2,cont2h)) = [];     % contour levels
   [c2,h2] = contour(dn,z,var2,cont2,'k');
   [ch,hh] = contour(dn,z,var2,cont2h,'k','linewidth',2);
   clabel(ch,hh);
   if isempty(cont2)
      set(h2,'levellistmode','auto');
   end
end

set(gca,'ydir','rev','ylim',ylim,'xlim',[dn(1) dn(end)],'clim',[cont1(1) cont1(end)]);
datetick('x','keeplimits');
ylabel(ylab)
title(titl)

extlab = var1str;
if strcmp(var1str,'t')
   extlab = 'Temperature (\circC)';
   colormap(jet(64));
elseif strcmp(var1str,'s')
   extlab = 'Salinity (psu)';
   colormap(jet(64));
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