function [A,meanmap,avmap,avmaptm,avmapnomean,avmapnomeantm,meanmapsig,avmapsig,avmapsignomean]=allanncyc(line)
% function [A,meanmap,avmap,avmapnomean,meanmapsig,avmapsig,avmapsignomean]=allanncyc(line)
% Given line one of {'90.0','80.0','66.7'} calculates annual cycle with all
% the parameters we like best.
% This is a wrapper function with lots of special numbers that could
% change.
%
% D. Rudnick, July 28, 2016
%***************************
% This is one of the first functions to run 
% Note some of the "special" numbers have been adjusted below to
% meet requirements for the Trinidad line that can't be met using the other
% line's data.  
% Modified combineMissions code below.
% 
% Additional notes FLB Oct, 24 2023
%***************************

%Lots of special numbers follow
yearend=2013;
maxharmonic=3;
%maxharmonic=3; % original value
xwidth=15;
winmin=1e-3;
sigsig=25:0.1:27;

if strcmp(line,'90.0')
   yearstart=2007;
   dist=0:5:530;
elseif strcmp(line,'80.0')
   yearstart=2007;
   dist=0:5:365;
elseif strcmp(line,'66.7')
   yearstart=2008;
   dist=0:5:400;
elseif strcmp(line,'Trin')
    yearstart=2014;
    yearend=2022;
%    dist=0:5:490;
    dist=0:10:490;
end

%ctd=combineMissions(line,0); % original load
ctd=combineMissionsTrinidad(line); % my load for Trinidad

A=annualcycleg(ctd,yearstart,yearend,maxharmonic,dist,xwidth,winmin);
%keyboard

meanmap=anncyc2meanmap(A);
meanmap=addderivedvars(meanmap);

avmap=anncyc2avmap(A);
avmap=addderivedvars(avmap);
avmaptm=topomask(avmap);
%keyboard;
avmapnomean=demeanavmap(avmap,meanmap);
avmapnomeantm=topomask(avmapnomean);

avmapsig=interpmap_sigma(avmaptm,sigsig);

[avmapsignomean,meanmapsig]=demeanmap(avmapsig);




