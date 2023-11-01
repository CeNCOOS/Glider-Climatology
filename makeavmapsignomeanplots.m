function makeavmapsignomeanplots(avmapsignomean,basepath)
% makeavmapsignomeanplots(avmapsignomean,basepath)
% function to make plots and write them given a basepath.
%
% D. Rudnick, August 2 2016

dirpath=fullfile(basepath,avmapsignomean.line(1:2),'avmapsignomean');

%xz
xzpath=fullfile(dirpath,'xz');
[~,~]=mkdir(xzpath);
%vars={'s','theta','geov','depth'}; % original
vars={'s','fl','ox','cdom','bb','theta','geov','depth'};

for k=1:length(vars)
   varpath=fullfile(xzpath,vars{k});
   [~,~]=mkdir(varpath);
   for n=1:10:length(avmapsignomean.time)
      pxz(avmapsignomean,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
      dnstr = char(ut2ds(avmapsignomean.time(n),'mm-dd'));
      print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_xz_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_xz_' vars{k} '_' dnstr]),'-djpeg');
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
   for n=1:length(avmapsignomean.sigma)
      if any(~isnan(avmapsignomean.(vars{k})(n,:)))
         pxtime(avmapsignomean,vars{k},vars{k},n,[],[0 100000],[9999 99999]);
         dnstr = num2str(avmapsignomean.sigma(n));
         print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_xtime_' vars{k} '_' dnstr '.eps']),'-depsc');
         print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_xtime_' vars{k} '_' dnstr '.eps']),'-djpeg');
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
      ptimez(avmapsignomean,vars{k},vars{k},1:n,[],[0 100000],[9999 99999]);
      dnstr = num2str(avmapsignomean.dist(n));
      print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_timez_' vars{k} '_' dnstr]),'-depsc');
      print(fullfile(varpath,[avmapsignomean.line(1:2) '_avmapsignomean_timez_' vars{k} '_' dnstr]),'-djpeg');
   end
end

