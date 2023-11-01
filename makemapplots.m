function makemapplots(map,maptm,ixz,basepath)

% function to make plots and write them given a basepath
%
% K.Zaba; Aug9,2016

% Plotting Parameters
cont2  = 20:0.25:30;
cont2h = 20:30;
% original
%timelim  = [datenum(2006,6,1) datenum(year(datetime('now'))+1,1,1)];
%timetick = datenum(2006:year(datetime('now'))+1,1,1);
timelim  = [datenum(2014,11,16) datenum(year(datetime('now'))+1,1,1)]; %#ok<DATNM> 
timetick = datenum(2014:year(datetime('now'))+1,1,1); %#ok<DATNM> 
xlabang = 35;

% Vars to plot
%vars={'t','s','theta','sigma','geov'};
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};
% vars={'fl'};

dirpath=fullfile(basepath,map.line(1:2),'map');

% xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
for k=1:length(vars)
    varpath=fullfile(xzpath,vars{k});
    [~,~]=mkdir(varpath);
    % for n=1:length(map.time)
    for n=ixz(1):ixz(end)
        if any(any(nanmean(map.(vars{k})(:,:,n),3))) %#ok<NANMEAN> 
            pxz(map,vars{k},'sigma',n,[],cont2,cont2h);
            dnstr = char(ut2ds(map.time(n),'yyyy-mm-dd'));
            print(fullfile(varpath,[map.line(1:2),'_map_xz_' vars{k} '_' dnstr]),'-depsc')
            print(fullfile(varpath,[map.line(1:2),'_map_xz_' vars{k} '_' dnstr]),'-djpeg')
        end
    end
end

% xtime
orient tall;
set(0,'defaultaxesfontsize',16);

xtimepath=fullfile(dirpath,'xtime');
[~,~]=mkdir(xtimepath);
for k=1:length(vars)
    varpath=fullfile(xtimepath,vars{k});
    [~,~]=mkdir(varpath);
    for n=1:length(maptm.depth)
        pxtime(maptm,vars{k},'',n,[],[],[]);
        set(gca,'ylim',timelim,'ytick',timetick)
        datetick('y','yyyy','keeplimits','keepticks')
        zstr = num2str(maptm.depth(n));
        print(fullfile(varpath,[maptm.line(1:2) '_map_xtime_' vars{k} '_' zstr]),'-depsc')
        print(fullfile(varpath,[maptm.line(1:2) '_map_xtime_' vars{k} '_' zstr]),'-djpeg')
    end
end

% varu={'ualong','uacross'};
% varpath=fullfile(xtimepath,'u');
% [~,~]=mkdir(varpath);
% for k=1:length(varu)
%     pxtime(map,varu{k},'',1,[],[],[]);
%     set(gca,'ylim',timelim,'ytick',timetick)
%     datetick('y','yyyy','keeplimits','keepticks')
%     print(fullfile(varpath,[map.line(1:2) '_map_xtime_' varu{k}]),'-depsc');
% end

close(gcf)
set(0,'defaultaxesfontsize',14)

% timez
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
for k=1:length(vars)
    varpath=fullfile(timezpath,vars{k});
    [~,~]=mkdir(varpath);
    for n=11:10:41
        ptimez(maptm,vars{k},'sigma',1:n,[],cont2,cont2h);
        set(gca,'xlim',timelim,'xtick',timetick,'xticklabelrotation',xlabang)
        datetick('x','yyyy','keeplimits','keepticks')
        xstr = num2str(maptm.dist(n));
        print(fullfile(varpath,[maptm.line(1:2) '_map_timez_' vars{k} '_' xstr]),'-depsc');
        print(fullfile(varpath,[maptm.line(1:2) '_map_timez_' vars{k} '_' xstr]),'-djpeg');
    end
end