function makeavmapsigplots(avmapsig,basepath)
% makeavmapsigplots(avmapsig,basepath)
% function to make plots and write them given a basepath.
%
% D. Rudnick, August 2 2016

dirpath=fullfile(basepath,avmapsig.line(1:2),'avmapsig');

%xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
%vars={'s','theta','geov','depth'}; % original
vars={'s','fl','ox','cdom','bb','theta','geov','depth'};

for k=1:length(vars)
   varpath=fullfile(xzpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:10:length(avmapsig.time)
      pxz(avmapsig,vars{k},[],n,[],[],[]);
      dnstr = char(ut2ds(avmapsig.time(n),'mm-dd'));
      print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_xz_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_xz_' vars{k} '_' dnstr]),'-djpeg');
   end
end

%xtime
xtimepath=fullfile(dirpath,'xtime');
[~,~]=mkdir(xtimepath);
%vars={'s','theta','geov','depth'};
vars={'s','fl','ox','cdom','bb','theta','geov','depth'};

for k=1:length(vars)
   varpath=fullfile(xtimepath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:length(avmapsig.sigma)
      if any(~isnan(avmapsig.(vars{k})(n,:)))
         pxtime(avmapsig,vars{k},[],n,[],[],[]);
         dnstr = num2str(avmapsig.sigma(n));
         print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_xtime_' vars{k} '_' dnstr '.eps']),'-depsc');
         print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_xtime_' vars{k} '_' dnstr '.eps']),'-djpeg');
      end
   end
end

%timez
timezpath=fullfile(dirpath,'timez');
[~,~]=mkdir(timezpath);
%vars={'s','theta','geov','depth'};
vars={'s','fl','ox','cdom','bb','theta','geov','depth'};

for k=1:length(vars)
   varpath=fullfile(timezpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=11:10:41
      ptimez(avmapsig,vars{k},[],1:n,[],[],[]);
      dnstr = num2str(avmapsig.dist(n));
      print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_timez_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapsig.line(1:2) '_avmapsig_timez_' vars{k} '_' dnstr]),'-djpeg');
   end
end

