function makeanommapsigplots_woa(anommapsig,ixz,basepath)

% function to make plots and write them given a basepath
%
% K.Zaba; Aug11,2016
% This plots on sigma leves etc.  Looks like it may need to be edited to
% have the other ancillary variables.
% FLB Oct. 25, 2023.

% Plotting Parameters
timelim  = [datenum(2014,11,1) datenum(year(datetime('now'))+1,1,1)]; %#ok<DATNM> 
timetick = datenum(2014:year(datetime('now'))+1,1,1); %#ok<DATNM> 
xlabang = 35;

% Vars to plot
vars={'s','theta','geov','depth'};
%vars={'s','fl','theta','geov','depth'};
% vars={'fl'};

dirpath=fullfile(basepath,anommapsig.line(1:2),'anommapsig');
%keyboard
% xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
for k=1:length(vars)
    varpath=fullfile(xzpath,vars{k});
    [~,~]=mkdir(varpath);
    % for n=1:length(anommapsig.time)
    for n=ixz(1):ixz(end)
        if any(any(nanmean(anommapsig.(vars{k})(:,:,n),3))) %#ok<NANMEAN> 
            pxz(anommapsig,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
            dnstr = char(ut2ds(anommapsig.time(n),'yyyy-mm-dd'));
            print(fullfile(varpath,[anommapsig.line(1:2),'_woa_anommapsig_xz_' vars{k} '_' dnstr]),'-depsc')
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
    for n=1:length(anommapsig.sigma)
        if any(~isnan(anommapsig.(vars{k})(n,:)))
            pxtime(anommapsig,vars{k},'',n,[],[],[]);
            set(gca,'ylim',timelim,'ytick',timetick)
            datetick('y','yyyy','keeplimits','keepticks')
            zstr = num2str(anommapsig.sigma(n));
            print(fullfile(varpath,[anommapsig.line(1:2) '_woa_anommapsig_xtime_' vars{k} '_' zstr '.eps']),'-depsc')
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
        ptimez(anommapsig,vars{k},vars{k},1:n,[],[0 100000],[9999 99999]);
        set(gca,'xlim',timelim,'xtick',timetick,'xticklabelrotation',xlabang)
        datetick('x','yyyy','keeplimits','keepticks')
        xstr = num2str(anommapsig.dist(n));
        print(fullfile(varpath,[anommapsig.line(1:2), '_woa_anommapsig_timez_' vars{k} '_' xstr]),'-depsc');
    end
end

% time
timepath=fullfile(dirpath,'time');
[~,~]=mkdir(timepath);
oni = downloadoni;
for k=1:length(vars)
    varpath=fullfile(timepath,vars{k});
    [~,~]=mkdir(varpath);
    for nx=11:10:41
        for nz=1:length(anommapsig.sigma)
            if any(~isnan(anommapsig.(vars{k})(nz,:)))
                ptimeONI(anommapsig,vars{k},nz,1:nx,oni);
                zstr = num2str(anommapsig.sigma(nz));
                xstr = num2str(anommapsig.dist(nx));
                print(fullfile(varpath,[anommapsig.line(1:2) '_woa_anommapsig_time_' vars{k} '_' zstr '_' xstr '.eps']),'-depsc')
            end
        end
    end
end