function makemeanmapplots(meanmap,basepath)
% makemeanplots(meanmap,basepath)
% function to make mean plots and write them given a basepath.
%
% D. Rudnick, August 2 2016

%Sigma levels to plot
cont2=20:0.25:30;
cont2h=20:30;
%Contour levels for other variables
cont1.t=5:0.5:17;
cont1.s=32.40:0.05:34.3;
cont1.fl=[];
cont1.ox=[];
cont1.cdom=[];
cont1.bb=[];
cont1.theta=[];
cont1.sigma=[];
cont1.geov=-0.1:0.005:0.1;

%Plot mean sections
dirpath=fullfile(basepath,meanmap.line(1:2),'meanmap');
[~,~]=mkdir(dirpath);
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};
%vars={'t','s','theta','sigma','geov'};
%keyboard
for k=1:length(vars)
   pxz(meanmap,vars{k},'sigma',1,cont1.(vars{k}),cont2,cont2h);
   %print(fullfile(dirpath,[meanmap.line(1:2) '_mean_xz_' vars{k}]),'-depsc');
   print(fullfile(dirpath,[meanmap.line(1:2) '_mean_xz_' vars{k}]),'-djpeg');
end
