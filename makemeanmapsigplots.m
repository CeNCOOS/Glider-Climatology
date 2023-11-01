function makemeanmapsigplots(meanmapsig,basepath)
% makemeanmapsigplots(meanmapsig,basepath)
% function to make plots and write them given a basepath.
%
% D. Rudnick, August 2 2016
% Modified to plot the rest of the ancillary variables.  Plots the data on
% sigma surfaces.
% FLB Oct. 25, 2023

dirpath=fullfile(basepath,meanmapsig.line(1:2),'meanmapsig');
[~,~]=mkdir(dirpath);
%vars={'s','theta','geov','depth'}; % original
vars={'s','fl','ox','cdom','bb','theta','geov','depth'};
for k=1:length(vars)
   pxz(meanmapsig,vars{k},'',1,[],[],[]);
   print(fullfile(dirpath,[meanmapsig.line(1:2) '_meanmapsig_xz_' vars{k}]),'-depsc');
   print(fullfile(dirpath,[meanmapsig.line(1:2) '_meanmapsig_xz_' vars{k}]),'-djpeg');
end
