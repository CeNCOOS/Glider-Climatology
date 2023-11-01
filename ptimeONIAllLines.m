function ptimeONIAllLines(mapstruct,var1str,iz,ix,oni)

% Plot timeseries for the input parameters:
    % 'mapstruct':  cell array of 'anommap' structures for lines 66,80,90
    % 'var1str':    variable to be plotted
    % 'iz':         depth indices to average over to make plot
    % 'ix':         distance indices to average over to make plot
    % 'oni':        the output structure of 'downloadoni', if empty then
    %               the data will be downloaded here
%
%
% K.Zaba: Aug29,2016

colors = cell(size(mapstruct));
nline = length(mapstruct);
for iiline=1:nline
    lineID = mapstruct{iiline}.line(1:2);
    if strcmp(lineID,'Tr')
        colors{iiline}='r';
    end
    % below is original code
    %if strcmp(lineID,'66')
    %    colors{iiline} = 'g';
    %elseif strcmp(lineID,'80')
    %    colors{iiline} = 'b';
    %elseif strcmp(lineID,'90')
    %    colors{iiline} = 'r';
    %end
end
xlabang = 35;

% Data
x = mapstruct{1}.dist;
if isvector(mapstruct{1}.depth)
    z = mapstruct{1}.depth;
    zunit = 'm';
else
    z = mapstruct{1}.sigma;
    zunit = 'kg/m^3';
end

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
titl=['All Lines, ' zstr ', ' xstr];

% Download ONI
if isempty(oni)
    oni = downloadoni;
end

% Plot
var1 = squeeze(nanmean(nanmean(mapstruct{1}.(var1str)(iz,ix,:),1),2)); %#ok<NANMEAN> 
dnrm = runmean(ut2dn(mapstruct{1}.time),9);
var1rm = runmean(var1,9);

[ax,h1,h2]=plotyy(runmean(oni.dn,3),runmean(oni.anom,3),dnrm,var1rm); %#ok<PLOTYY> 
set(h2,'color',colors{1},'linewidth',2);

hold(ax(2),'on');
for iiline=2:3
    var1 = squeeze(nanmean(nanmean(mapstruct{iiline}.(var1str)(iz,ix,:),1),2)); %#ok<NANMEAN> 
    dnrm = runmean(ut2dn(mapstruct{iiline}.time),9);
    var1rm = runmean(var1,9);
    h2(iiline) = plot(ax(2),dnrm,var1rm,colors{iiline},'linewidth',2);
end
hold(ax(2),'off');

% [yy,mm,~] = datevec(dnrm);
% if mm<7
%     xmax = datenum(yy(end),7,1);
%     xtick = datenum(2007:yy(end),1,1);
% else
%     xmax = datenum(yy(end)+1,1,1);
%     xtick = datenum(2007:yy(end)+1,1,1);
% end
% xmin = datenum(2006,6,1);
%
% New code will need 2014 not 2007
% original
%xmin = datenum(2007,1,1); %#ok<DATNM> 
%xmax = datenum(year(datetime('now'))+1,1,1); %#ok<DATNM> 
%xtick = datenum(2007:year(datetime('now'))+1,1,1); %#ok<DATNM> 
%
xmin = datenum(2015,1,1); %#ok<DATNM> 
xmax = datenum(year(datetime('now'))+1,1,1); %#ok<DATNM> 
xtick = datenum(2015:year(datetime('now'))+1,1,1); %#ok<DATNM> 

set(ax(2),'ylimmode','auto');
ylim=get(ax(2),'ylim');
ylim=max(abs(ylim));
set(ax,'xlim',[xmin xmax],'xtick',xtick,'xticklabelrotation',xlabang);
set(ax(2),'ycolor','k','ylim',[-ylim ylim],'ytickmode','auto','yaxislocation','left');
set(ax(1),'ycolor','k','ylim',[-4 4],'ytick',-4:4,'yaxislocation','right','xgrid','on');
set(h1,'color','k','linewidth',2);
hold on; plot(ax(1),[xmin xmax]',[0 0; 4 4]','k','linewidth',0.5); hold off;

ylab = var1str; 
if strcmp(var1str,'t')
    ylab = 'Temperature (\circC)';
elseif strcmp(var1str,'s')
    ylab = 'Salinity (psu)';
% new code
elseif strcmp(varlstr,'ox')
	ylab='Oxygen';
elseif strcmp(varlstr,'fl')
	ylab='Fluorescence';
elseif strcmp(varlstr,'cdom')
	ylab='CDOM';
elseif strcmp(varlstr,'bb')
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
if (isfield(mapstruct{1},'isanom') && mapstruct{1}.isanom)
    ylab = ['Anomaly of ' ylab];
end

datetick('x','yyyy','keeplimits','keepticks');
legend([h2 h1], ...
       ['Line ' mapstruct{1}.line],['Line ' mapstruct{2}.line],['Line ' mapstruct{3}.line], ...
       'Oceanic Nino Index','location','southwest')
ylabel(ax(2),ylab);
ylabel(ax(1),'Oceanic Nino Index (\circC)');
title(titl)
box off;
    
end