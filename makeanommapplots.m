function makeanommapplots(anommap,anommaptm,ixz,basepath)

% function to make plots and write them given a basepath
%
% K.Zaba; Aug11,2016
% This is one of the big anomaly plotting routines called by
% wrapperanomplots.
% FLB Oct. 25, 2023

% Plotting Parameters
% original
%timelim  = [datenum(2006,6,1) datenum(year(datetime('now'))+1,1,1)]; %#ok<DATNM> 
%timetick = datenum(2006:year(datetime('now'))+1,1,1); %#ok<DATNM> 
% new
timelim  = [datenum(2015,1,1) datenum(year(datetime('now'))+1,1,1)]; %#ok<DATNM> 
timetick = datenum(2015:year(datetime('now'))+1,1,1); %#ok<DATNM> 
xlabang = 35;

% Vars to plot
%vars={'t','s','theta','sigma','geov'}; % original
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};
% vars={'fl'};

dirpath=fullfile(basepath,anommap.line(1:2),'anommap');

% xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
for k=1:length(vars)
    varpath=fullfile(xzpath,vars{k});
    [~,~]=mkdir(varpath);
    % for n=1:length(anommap.time)
    for n=ixz(1):ixz(end)
        if any(any(nanmean(anommap.(vars{k})(:,:,n),3))) %#ok<NANMEAN> 
            pxz(anommap,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
            dnstr = char(ut2ds(anommap.time(n),'yyyy-mm-dd'));
            print(fullfile(varpath,[anommap.line(1:2),'_anommap_xz_' vars{k} '_' dnstr]),'-depsc')
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
    for n=1:length(anommaptm.depth)
        pxtime(anommaptm,vars{k},'',n,[],[],[]);
        set(gca,'ylim',timelim,'ytick',timetick)
        datetick('y','yyyy','keeplimits','keepticks')
        zstr = num2str(anommaptm.depth(n));
        print(fullfile(varpath,[anommaptm.line(1:2) '_anommap_xtime_' vars{k} '_' zstr]),'-depsc')
    end
end

%varu={'ualong','uacross'};
%varpath=fullfile(xtimepath,'u');
%[~,~]=mkdir(varpath);
%for k=1:length(varu)
%    pxtime(anommap,varu{k},'',1,[],[],[]);
%    set(gca,'ylim',timelim,'ytick',timetick)
%    datetick('y','yyyy','keeplimits','keepticks')
%    print(fullfile(varpath,[anommap.line(1:2) '_anommap_xtime_' varu{k}]),'-depsc');
%end

%close(gcf)
set(0,'defaultaxesfontsize',14)

% time z
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
for k=1:length(vars)
    varpath=fullfile(timezpath,vars{k});
    [~,~]=mkdir(varpath);
    for n=11:10:41
        ptimez(anommaptm,vars{k},vars{k},1:n,[],[0 100000],[9999 99999]);
        set(gca,'xlim',timelim,'xtick',timetick,'xticklabelrotation',xlabang)
        datetick('x','yyyy','keeplimits','keepticks')
        xstr = num2str(anommaptm.dist(n));
        print(fullfile(varpath,[anommaptm.line(1:2) '_anommap_timez_' vars{k} '_' xstr]),'-depsc');
    end
end

% time
timepath=fullfile(dirpath,'time');
[~,~]=mkdir(timepath);
oni = downloadoni;
for k=1:length(vars)
    varpath=fullfile(timepath,vars{k});
    [~,~]=mkdir(varpath);
    for nx = 11:10:41
        for nz=1:length(anommaptm.depth)
            ptimeONI(anommaptm,vars{k},nz,1:nx,oni);
            zstr = num2str(anommaptm.depth(nz));
            xstr = num2str(anommaptm.dist(nx));
            print(fullfile(varpath,[anommaptm.line(1:2) '_anommap_time_' vars{k} '_' zstr '_' xstr]),'-depsc');
        end
    end
end