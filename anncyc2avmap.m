function avmap=anncyc2avmap(A)
% function avmap=anncyc2avmap
% Takes annual cycle structure A and makes structure avmap with t, s, u, v
% every day.  Uses 2007 as the year.
%
% D. Rudnick, July 28, 2016
%
% Code does as above but has been modified to have a new "year" since 
% 2007 was before the Trinidad line was started.  The cannonical year has 
% been set to 2015.  Additionally the ancillary variables oxygen (ox),
% fluorescence (fl), colored dissolved organic matter (cdom) and
% backscatter (bb) have been added to the average map structure and output.
% This function is called by allanncyc.m
%
% Update notes FLB Oct. 24 2023

nlev=length(A.depth);
nbin=length(A.xcenter);

avmap.line=A.line;
avmap.depth=A.depth;
avmap.dist=A.xcenter;
avmap.lat=A.lat;
avmap.lon=A.lon;
avmap.time=dn2ut(datenum(2015,1,1):datenum(2015,12,31))';  % adjust to time period
%avmap.time=dn2ut(datenum(2007,1,1):datenum(2007,12,31))'; %#ok<DATNM>
%original line is 2007
ntime=length(avmap.time);
avmap.t=nan(nlev,nbin,ntime);
avmap.s=nan(nlev,nbin,ntime);
avmap.fl=nan(nlev,nbin,ntime);
avmap.ox=nan(nlev,nbin,ntime);
avmap.cdom=nan(nlev,nbin,ntime);
avmap.bb=nan(nlev,nbin,ntime);
avmap.u=nan(nbin,ntime);
avmap.v=nan(nbin,ntime);

timebin=2*pi*avmap.time/86400/365.25;
maxharmonic=size(A.t.sin,3);
G=[ones(size(timebin)) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
for n=1:nlev
   for m=1:nbin
      mm=[A.t.constant(n,m); squeeze(A.t.sin(n,m,:)); squeeze(A.t.cos(n,m,:))];
      avmap.t(n,m,:)=G*mm;
      
      mm=[A.s.constant(n,m); squeeze(A.s.sin(n,m,:)); squeeze(A.s.cos(n,m,:))];
      avmap.s(n,m,:)=G*mm;
      
      mm=[A.fl.constant(n,m); squeeze(A.fl.sin(n,m,:)); squeeze(A.fl.cos(n,m,:))];
      avmap.fl(n,m,:)=G*mm;
      
      mm=[A.ox.constant(n,m); squeeze(A.ox.sin(n,m,:)); squeeze(A.ox.cos(n,m,:))];
      avmap.ox(n,m,:)=G*mm;
      
      mm=[A.cdom.constant(n,m); squeeze(A.cdom.sin(n,m,:)); squeeze(A.cdom.cos(n,m,:))];
      avmap.cdom(n,m,:)=G*mm;
    
      mm=[A.bb.constant(n,m); squeeze(A.bb.sin(n,m,:)); squeeze(A.bb.cos(n,m,:))];
      avmap.bb(n,m,:)=G*mm;
         
   end
end

for m=1:nbin
   mm=[A.u.constant(m); A.u.sin(m,:)'; A.u.cos(m,:)'];
   avmap.u(m,:)=G*mm;
   
   mm=[A.v.constant(m); A.v.sin(m,:)'; A.v.cos(m,:)'];
   avmap.v(m,:)=G*mm;
end
