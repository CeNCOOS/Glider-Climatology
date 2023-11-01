function [c1,h1,c2,h2] = pxtime(mapstruct,var1str,var2str,iz,cont1,cont2,cont2h)

% Plot sections for the input parameters:
    % 'mapstruct':  'map','avmap', or 'anommap'
    % 'var1str':    variable to be plotted with a color contour
    % 'var2str':    variable to be plotted with a black contour
    % 'iz':         z indices to average over to make plot, either depth or sigma
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
% Modified to handle glider ancillary variables.  
%  FLB Oct. 25, 2023

% Data
x = mapstruct.dist;
dn = ut2dn(mapstruct.time);
if isvector(mapstruct.depth)
    z = mapstruct.depth;
    units = ' m';
else
    z = mapstruct.sigma;
    units = ' kg/m^3';
end

if ndims(mapstruct.(var1str)) == 3
   var1 = squeeze(nanmean(mapstruct.(var1str)(iz,:,:),1))'; %#ok<NANMEAN> 
   if isscalar(iz)
      dnstr = [num2str(z(iz)) units];
   else
      dnstr=[num2str(z(iz(1))) ' - ' num2str(z(iz(end))) units];
   end
else
   var1 = mapstruct.(var1str)';
   dnstr='Depth Average';
end
titl=['Line ' mapstruct.line ', ' dnstr];

% Plot 
[c1,h1] = contourf(x,dn,var1,cont1,'linestyle','none');
if isempty(cont1)
   set(h1,'levellistmode','auto');
   cont1=get(h1,'levellist');
   try
        dc=cont1(end)-cont1(end-1);
   catch
       % what if we set cont1(2)=1 and cont1(1)=0? cont1=[]
       cont1(2)=1;
       cont1(1)=0;
       dc=cont1(end)-cont1(end-1);
    %keyboard;
   end
   if any(strcmp(var1str,{'geov','u','v','ualong','uacross'})) || (isfield(mapstruct,'isanom') && mapstruct.isanom)
      if abs(cont1(end)) > abs(cont1(1))
         cont1=-cont1(end):dc/2:cont1(end)+eps;
      else
         cont1=cont1(2)-dc:dc/2:-cont1(2)+dc+eps;
      end
   else
      cont1=cont1(2)-dc:dc/2:cont1(end)+dc+eps;
   end
   clf('reset');
   [c1,h1] = contourf(x,dn,var1,cont1,'linestyle','none');
end

hold on;

if ~isempty(var2str)
   if ndims(mapstruct.(var2str)) == 3
      var2 = squeeze(nanmean(mapstruct.(var2str)(iz,:,:),1))'; %#ok<NANMEAN> 
   else
      var2 = mapstruct.(var2str)';
   end
   cont2(ismember(cont2,cont2h)) = [];     % contour levels
   [c2,h2] = contour(x,dn,var2,cont2,'k');
   [ch,hh] = contour(x,dn,var2,cont2h,'k','linewidth',2);
   clabel(ch,hh);
   if isempty(cont2)
      set(h2,'levellistmode','auto');
   end
end

set(gca,'xdir','rev','xlim',[x(1) x(end)],'ylim',[dn(1) dn(end)],'clim',[cont1(1) cont1(end)]);
datetick('y','keeplimits');
xlabel('Offshore Distance (km)')
title(titl)

extlab = var1str;
if strcmp(var1str,'t')
   extlab = 'Temperature (\circC)';
   colormap(jet(64));
elseif strcmp(var1str,'s')
   extlab = 'Salinity (psu)';
   colormap(jet(64));
% new code
elseif strcmp(var1str,'ox')
	extlab='Oxygen';
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
% end of new code
elseif strcmp(var1str,'geov')
   extlab='Geostrophic Velocity (m/s)';
   colormap(redblue(length(cont1)-1));
elseif strcmp(var1str,'ualong')
   extlab='Alongshore Velocity (m/s)';
   colormap(redblue(length(cont1)-1));
elseif strcmp(var1str,'uacross')
   extlab='Across-shore Velocity (m/s)';
   colormap(redblue(length(cont1)-1));
elseif strcmp(var1str,'u')
   extlab='Eastward Velocity (m/s)';
   colormap(redblue(length(cont1)-1));
elseif strcmp(var1str,'v')
   extlab='Northward Velocity (m/s)';
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