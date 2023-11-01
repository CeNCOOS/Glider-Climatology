function makeavmapplots(avmap,avmaptm,basepath)
% makeavmapplots(avmap,avmaptm,basepath)
% function to make plots and write them given a basepath.
%
% D. Rudnick, August 2 2016
% This has been set up to plot the averages with the other variables.
% FLB Oct. 25, 2023

%Sigma levels to plot
cont2=20:0.25:30;
cont2h=20:30;

dirpath=fullfile(basepath,avmap.line(1:2),'avmap');

%xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
%vars={'t','s','theta','sigma','geov'}; % original
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};
for k=1:length(vars)
   varpath=fullfile(xzpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:10:length(avmap.time)
      pxz(avmap,vars{k},'sigma',n,[],cont2,cont2h);
      dnstr = char(ut2ds(avmap.time(n),'mm-dd'));
      print(fullfile(varpath,[avmap.line(1:2) '_avmap_xz_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmap.line(1:2) '_avmap_xz_' vars{k} '_' dnstr]),'-djpeg');     
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
   for n=1:length(avmaptm.depth)
      pxtime(avmaptm,vars{k},'',n,[],[],[]);
      dnstr = num2str(avmaptm.depth(n));
      print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_xtime_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_xtime_' vars{k} '_' dnstr]),'-djpeg');
   end
end

%vars={'ualong','uacross'};
%varpath=fullfile(xtimepath,'u');
%[~,~]=mkdir(varpath);
%for k=1:length(vars)
%   pxtime(avmaptm,vars{k},'',1,[],[],[]);
%   print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_xtime_' vars{k}]),'-depsc');
%   print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_xtime_' vars{k}]),'-djpeg');
%end

%timez
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
%vars={'t','s','theta','sigma','geov'};
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};
for k=1:length(vars)
   varpath=fullfile(timezpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=11:10:41
      ptimez(avmaptm,vars{k},'sigma',1:n,[],cont2,cont2h);
      dnstr = num2str(avmaptm.dist(n));
      print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_timez_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmaptm.line(1:2) '_avmap_timez_' vars{k} '_' dnstr]),'-djpeg');
   end
end

