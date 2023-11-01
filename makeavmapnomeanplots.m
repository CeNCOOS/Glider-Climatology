function makeavmapnomeanplots(avmapnomean,avmapnomeantm,basepath)
% makeavmapnomeanplots(avmapnomean,avmapnomeantm,basepath)
% function to make plots and write them given a basepath.
%
% D. Rudnick, August 2 2016
%
% This plots the average plots without the mean and has also been modified to have the
% ancillary variables plotted also.
% FLB Oct. 25, 2023

dirpath=fullfile(basepath,avmapnomean.line(1:2),'avmapnomean');

%xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
%vars={'t','s','theta','sigma','geov'};% original
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};

for k=1:length(vars)
   varpath=fullfile(xzpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:10:length(avmapnomean.time)
      pxz(avmapnomean,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
      dnstr = char(ut2ds(avmapnomean.time(n),'mm-dd'));
      print(fullfile(varpath,[avmapnomean.line(1:2) '_avmapnomean_xz_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapnomean.line(1:2) '_avmapnomean_xz_' vars{k} '_' dnstr]),'-djpeg');
   end
end

%xtime
xtimepath=fullfile(dirpath,'xtime');
[~,~]=mkdir(xtimepath);
%vars={'t','s','theta','sigma','geov'};
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};

for k=1:length(vars)
   varpath=fullfile(xtimepath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:length(avmapnomeantm.depth)
      pxtime(avmapnomeantm,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
      dnstr = num2str(avmapnomeantm.depth(n));
      print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_xtime_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_xtime_' vars{k} '_' dnstr]),'-djpeg');
   end
end

%vars={'ualong','uacross'};
%varpath=fullfile(xtimepath,'u');
%[~,~]=mkdir(varpath);
%for k=1:length(vars)
%   pxtime(avmapnomeantm,vars{k},vars{k},1,[],[0 100000],[9999 99999]);
%   print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_xtime_' vars{k}]),'-depsc');
%   print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_xtime_' vars{k}]),'-djpeg');
%end

%timez
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};

%vars={'t','s','theta','sigma','geov'};
for k=1:length(vars)
   varpath=fullfile(timezpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=11:10:41
      ptimez(avmapnomeantm,vars{k},vars{k},1:n,[],[0 100000],[9999 99999]);
      dnstr = num2str(avmapnomeantm.dist(n));
      print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_timez_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapnomeantm.line(1:2) '_avmapnomean_timez_' vars{k} '_' dnstr]),'-djpeg');
   end
end

