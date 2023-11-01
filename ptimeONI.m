function [dn,var1] = ptimeONI(mapstruct,var1str,iz,ix,oni)

% Plot timeseries for the input parameters:
    % 'mapstruct':  'anommap'
    % 'var1str':    variable to be plotted
    % 'iz':         depth indices to average over to make plot
    % 'ix':         distance indices to average over to make plot
    % 'oni':        the output structure of 'downloadoni', if empty then
    %               the data will be downloaded here
%
%
% K.Zaba: Aug15,2016
% D. Rudnick, September 2, 2016
%
% Plot the data with the ONI 
% code is modified to plot with the glider's ancillary variables.
% FLB Oct. 25, 2023


% Plot Parameters
lineID0 = mapstruct.line(1:2);
if strcmp(lineID0,'66')
    linecolor = 'g';
elseif strcmp(lineID0,'80')
    linecolor = 'b';
elseif strcmp(lineID0,'90')
    linecolor = 'r';
end
linecolor='r';
xlabang = 35;

% Data
dn = ut2dn(mapstruct.time);
x = mapstruct.dist;
if isvector(mapstruct.depth)
    z = mapstruct.depth;
    zunit = 'm';
else
    z = mapstruct.sigma;
    zunit = 'kg/m^3';
end

var1 = squeeze(nanmean(nanmean(mapstruct.(var1str)(iz,ix,:),1),2)); %#ok<NANMEAN> 
dnrm = runmean(dn,9);
var1rm = runmean(var1,9);

if isscalar(ix)
    xstr = [num2str(x(ix)) ' km'];
else
    xstr = [num2str(x(ix(1))) ' - ' num2str(x(ix(end))) ' km'];
end
if isscalar(iz)
    zstr = [num2str(z(iz)) ' ' zunit];
else 
    zstr = [num2str(z(iz(1))) ' - ' num2str(z(iz(end))) ' ' zunit];
end
titl=['Line ' mapstruct.line ', ' zstr ', ' xstr];

% Download ONI
if isempty(oni)
    oni = downloadoni;
end

% Plot
[ax,h1,h2]=plotyy(runmean(oni.dn,3),runmean(oni.anom,3),dnrm,var1rm); %#ok<PLOTYY> 

% [yy,mm,~] = datevec(dnrm);
% if mm(end) < 7
%     xmax = datenum(yy(end),7,1);
%     xtick = datenum(2007:yy(end),1,1);
% else 
%     xmax = datenum(yy(end)+1,1,1);
%     xtick = datenum(2007:yy(end)+1,1,1);
% end
% xmin=datenum(2006,6,1);

xmin = datenum(2014,1,1); %#ok<DATNM> 
xmax = datenum(year(datetime('now'))+1,1,1); %#ok<DATNM> 
xtick = datenum(2014:year(datetime('now'))+1,1,1); %#ok<DATNM> 

ylim=get(ax(2),'ylim');
ylim=max(abs(ylim));
set(ax,'xlim',[xmin xmax],'xtick',xtick,'xticklabelrotation',xlabang);
set(ax(2),'ycolor',linecolor,'ylim',[-ylim ylim],'ytickmode','auto','yaxislocation','left');
set(ax(1),'ycolor','k','ylim',[-4 4],'ytick',-4:4,'yaxislocation','right','xgrid','on');
set(h2,'color',linecolor,'linewidth',2);
set(h1,'color','k','linewidth',2);
hold on; plot(ax(1),[xmin xmax]',[0 0; 4 4]','k','linewidth',0.5); hold off;

ylab = var1str;
if strcmp(var1str,'t')
    ylab = 'Temperature (\circC)';
elseif strcmp(var1str,'s')
    ylab = 'Salinity (psu)';
% new code
elseif strcmp(var1str,'ox')
	ylab='Oxygen';
elseif strcmp(var1str,'fl')
	ylab='Fluorescence';
elseif strcmp(var1str,'cdom')
	ylab='CDOM';
elseif strcmp(var1str,'bb')
	ylab='bb';
% end of new code
elseif strcmp(var1str,'geov')
    ylab = 'Geostrophic Velocity (m/s)';
elseif strcmp(var1str,'theta')
    ylab = 'Potential Temperature (\circC)';
elseif strcmp(var1str,'sigma')
    ylab = 'Potential Density (kg/m^3)';
elseif strcmp(var1str,'depth')
    ylab = 'Depth (m)';
end
if (isfield(mapstruct,'isanom') && mapstruct.isanom)
    ylab = ['Anomaly of ' ylab];
end

datetick('x','yyyy','keeplimits','keepticks');
ylabel(ax(2),ylab);
ylabel(ax(1),'Oceanic Nino Index (\circC)');
title(titl);
box off;
legend([h2,h1],['Line ' lineID0],'Oceanic Nino Index','Location','southwest')

end