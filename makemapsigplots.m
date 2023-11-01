function makemapsigplots(mapsig,ixz,basepath)

% function to make plots and write them given a basepath
%
% K.Zaba; Aug10,2016

% Plotting Parameters
timelim  = [datenum(2006,6,1) datenum(year(datetime('now'))+1,1,1)];
timetick = datenum(2006:year(datetime('now'))+1,1,1);
xlabang = 35;

% Vars to plot
vars={'s','theta','geov','depth'};
% vars={'fl'};

dirpath=fullfile(basepath,mapsig.line(1:2),'mapsig');

% xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
for k=1:length(vars)
    varpath=fullfile(xzpath,vars{k});
    [~,~]=mkdir(varpath);
    % for n=1:length(mapsig.time)
    for n=ixz(1):ixz(end)
        if any(any(nanmean(mapsig.(vars{k})(:,:,n),3)))
            pxz(mapsig,vars{k},[],n,[],[],[]);
            dnstr = char(ut2ds(mapsig.time(n),'yyyy-mm-dd'));
            print(fullfile(varpath,[mapsig.line(1:2) '_mapsig_xz_' vars{k} '_' dnstr]),'-depsc');
        end
    end
end

% xtime
orient tall
set(0,'defaultaxesfontsize',16)

xtimepath=fullfile(dirpath,'xtime');
[~,~]=mkdir(xtimepath);
for k=1:length(vars)
    varpath=fullfile(xtimepath,vars{k});
    [~,~]=mkdir(varpath);
    for n=1:length(mapsig.sigma)
        if any(~isnan(mapsig.(vars{k})(n,:)))
            pxtime(mapsig,vars{k},[],n,[],[],[]);
            set(gca,'ylim',timelim,'ytick',timetick)
            datetick('y','yyyy','keeplimits','keepticks')
            zstr = num2str(mapsig.sigma(n));
            print(fullfile(varpath,[mapsig.line(1:2) '_mapsig_xtime_' vars{k} '_' zstr '.eps']),'-depsc')
        end
    end
end

close(gcf)
set(0,'defaultaxesfontsize',14)

% timez
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
for k=1:length(vars)
    varpath=fullfile(timezpath,vars{k});
    [~,~]=mkdir(varpath);
    for n=11:10:41
        ptimez(mapsig,vars{k},[],1:n,[],[],[]);
        set(gca,'xlim',timelim,'xtick',timetick,'xticklabelrotation',xlabang)
        datetick('x','yyyy','keeplimits','keepticks')
        xstr = num2str(mapsig.dist(n));
        print(fullfile(varpath,[mapsig.line(1:2) '_mapsig_timez_' vars{k} '_' xstr]),'-depsc');
    end
end