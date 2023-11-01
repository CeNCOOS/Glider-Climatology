function makeseasonsplots(avmap,basepath)
%
% Make seasonal plots and use all the ancillary variables (modified from
% the original).  
%
% FLB Oct. 25, 2023

cont2 = 22:0.25:28;     % sigma contours
cont2h = 22:1:27;       % bold sigma contours
%Contour levels for other variables
cont1.t=5:0.5:19;
cont1.s=32.40:0.05:34.3;
cont1.fl=[];
cont1.ox=[];
cont1.cdom=[];
cont1.bb=[];
cont1.theta=[];
cont1.sigma=[];
cont1.geov=-0.16:0.01:0.16;

dv=datevec(ut2dn(avmap.time));

dirpath=fullfile(basepath,avmap.line(1:2),'seasons');
[~,~]=mkdir(dirpath);

%winter
season='winter';
ii=dv(:,2) <=2 | dv(:,2) == 12;
%vars={'t','s','theta','sigma','geov'}; % original
vars={'t','s','fl','ox','cdom','bb','theta','sigma','geov'};

for k=1:length(vars)
   pxz(avmap,vars{k},'sigma',ii,cont1.(vars{k}),cont2,cont2h);
   title(['Line ' avmap.line ', ' season]);
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-depsc');
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-djpeg');
end


%spring
season='spring';
ii=dv(:,2) <= 5 & dv(:,2) >= 3;

for k=1:length(vars)
   pxz(avmap,vars{k},'sigma',ii,cont1.(vars{k}),cont2,cont2h);
   title(['Line ' avmap.line ', ' season]);
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-depsc');
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-djpeg');
end

%summer
season='summer';
ii=dv(:,2) <= 8 & dv(:,2) >= 6;

for k=1:length(vars)
   pxz(avmap,vars{k},'sigma',ii,cont1.(vars{k}),cont2,cont2h);
   title(['Line ' avmap.line ', ' season]);
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-depsc');
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-djpeg');
end

%fall
season='fall';
ii=dv(:,2) <= 11 & dv(:,2) >= 9;

for k=1:length(vars)
   pxz(avmap,vars{k},'sigma',ii,cont1.(vars{k}),cont2,cont2h);
   title(['Line ' avmap.line ', ' season]);
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-depsc');
   print(fullfile(dirpath,[avmap.line(1:2) '_xz_' vars{k} '_' season]),'-djpeg');
end
