function A=annualcycleg(ctd,yearstart,yearend,maxharmonic,xcenter,xwidth,winmin)
% function A=annualcycleg(ctd,yearstart,yearend,maxharmonic,xcenter,xwidth,winmin)
% Calculates annual cycle structure A given ctd structure from
% combineMissions. Arguments are:
% yearstart: start year
% yearend: end year
% maxharmonic: maximum annual harmonic. 3 for fundamental plus two.
% xcenter: center of bins along line
% xwidth: e-folding scale of Gaussian window, can be scalar or vector
% winmin: minimum value of window below which to set to zero (1e-3  works
% OK), to keep calculation smaller
%
%D. Rudnick, September 7, 2016
%
% This code computes the fit.  Modified to use singular value
% decomposition.  This code is called by allanncyc and returns the fit
% structure that is used by other pieces of code later.
%  The code has been modified to run the other ancillary variables.  It
%  spells them out specifically, it might be better to make this generic.
% The fit uses 3 harmonics as specified in allancyc.m
%
% Updated notes FLB Oct. 24, 2023

% number of levels and number of bins in x
nlev=size(ctd.t,1);
nbin=length(xcenter);

% single width or vector of widths
if isscalar(xwidth)
   xwidth=xwidth*ones(size(xcenter));
end
search=sqrt(-log(winmin))*xwidth;

% initialize
A.line=ctd.line;
A.window='gaussian';
A.winmin=winmin;
A.yearstart=yearstart;
A.yearend=yearend;
A.xcenter=xcenter(:);
A.xwidth=xwidth(:);
[A.lon,A.lat]=calcposalonglineCRM(A.xcenter,A.line);
A.depth=ctd.depth;
A.t.constant=nan(nlev,nbin);
A.t.sin=nan(nlev,nbin,maxharmonic);
A.t.cos=nan(nlev,nbin,maxharmonic);
A.s.constant=nan(nlev,nbin);
A.s.sin=nan(nlev,nbin,maxharmonic);
A.s.cos=nan(nlev,nbin,maxharmonic);
% Let us initialize fl, ox, cdom, bb
A.fl.constant=nan(nlev,nbin);
A.fl.sin=nan(nlev,nbin,maxharmonic);
A.fl.cos=nan(nlev,nbin,maxharmonic);
A.ox.constant=nan(nlev,nbin);
A.ox.sin=nan(nlev,nbin,maxharmonic);
A.ox.cos=nan(nlev,nbin,maxharmonic);
A.cdom.constant=nan(nlev,nbin);
A.cdom.sin=nan(nlev,nbin,maxharmonic);
A.cdom.cos=nan(nlev,nbin,maxharmonic);
A.bb.constant=nan(nlev,nbin);
A.bb.sin=nan(nlev,nbin,maxharmonic);
A.bb.cos=nan(nlev,nbin,maxharmonic);
% the lines below will not be used but putting this in so we don't have to
% edit so much
A.u.constant=nan(nbin,1);
A.u.sin=nan(nbin,maxharmonic);
A.u.cos=nan(nbin,maxharmonic);
A.v.constant=nan(nbin,1);
A.v.sin=nan(nbin,maxharmonic);
A.v.cos=nan(nbin,maxharmonic);

% get data between yearstart and yearend
%dv=datevec(ut2dn(ctd.time)); % ctd.time is already in the correct format % original
%no need to use ut2dn which messes things up causes empty arrays.
dv=datevec(ctd.time); % use for Trinidad files
ii=dv(:,1) >= yearstart & dv(:,1) <= yearend;
tmp=dn2ut(ctd.time); % new time in wrong format
%time=2*pi*ctd.time(ii)/86400/365.25; % original
time=2*pi*tmp/86400/365.25; % time adjusted to new format
dist=ctd.dist(ii);
t=ctd.t(:,ii);
%tm=nanmean(nanmean(t));
%t=t-13;
s=ctd.s(:,ii);
fl=ctd.fl(:,ii);
ox=ctd.ox(:,ii);
cdom=ctd.cdom(:,ii);
bb=ctd.bb(:,ii);
%keyboard;
%do each level 
for n=1:nlev
   kk=~isnan(t(n,:)); %start with temperature
   tlev=t(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   for m=1:nbin
      jj=(distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m)));
      %keyboard;
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];
      num=length(tbin);

     % keyboard;
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
%         G=[ones(num,1) sin(timebin*(1))];
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))]; %original
         WG=W*G; % original
%         B=G;
         B=WG'*G;
%         B=W*G;
%         keyboard;
%         y=W*tbin;
         y=WG'*tbin;
%          y=tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
%         keyboard;
%         mm=(WG'*G)\(WG'*tbin); % original
         %mm=(G'*G)\(G'*tbin); % try unweighted fit
%         if (n==5) && (m==45)
%            keyboard
%         end
         %keyboard;
         A.t.constant(n,m)=mm(1);
         %A.t.sin(n,m,:)=mm(2);
         A.t.sin(n,m,:)=mm(2:maxharmonic+1); % original
         A.t.cos(n,m,:)=mm(maxharmonic+2:end); %original
      end
   end
end
%keyboard
for n=1:nlev   
   kk=~isnan(s(n,:)); % now salinity
   tlev=s(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   
   ll=tlev > 11;
   tlev=tlev(ll);
   timelve=timelev(ll); %#ok<NASGU> 
   distlev=distlev(ll);
   for m=1:nbin
      jj=((distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m))));
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];      
      num=length(tbin);
      
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
         %WG=W*G;
         B=W*G;
         y=W*tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
         %mm=(WG'*G)\(WG'*tbin);
         
         A.s.constant(n,m)=mm(1);
         A.s.sin(n,m,:)=mm(2:maxharmonic+1);
         A.s.cos(n,m,:)=mm(maxharmonic+2:end);
      end
   end

   kk=~isnan(fl(n,:)); %  now fl
   tlev=fl(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   for m=1:nbin
      jj=((distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m))));
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];      
      num=length(tbin);
      
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
         WG=W*G;
         B=W*G;
         y=W*tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
         %mm=(WG'*G)\(WG'*tbin);
         
         A.fl.constant(n,m)=mm(1);
         A.fl.sin(n,m,:)=mm(2:maxharmonic+1);
         A.fl.cos(n,m,:)=mm(maxharmonic+2:end);
      end
   end
   kk=~isnan(ox(n,:)); % now oxygen
   tlev=ox(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   ll=tlev > 30;
   tlev=tlev(ll);
   timelev=timelev(ll);
   distlev=distlev(ll);
   for m=1:nbin
      jj=((distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m))));
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];
      
      num=length(tbin);
      
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
         %WG=W*G;
         %mm=(WG'*G)\(WG'*tbin);
         B=W*G;
         y=W*tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
         
         A.ox.constant(n,m)=mm(1);
         A.ox.sin(n,m,:)=mm(2:maxharmonic+1);
         A.ox.cos(n,m,:)=mm(maxharmonic+2:end);
      end
   end
   kk=~isnan(cdom(n,:));  % now cdom
   tlev=cdom(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   for m=1:nbin
      jj=((distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m))));
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];
      
      num=length(tbin);
      
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
         %WG=W*G;
         %mm=(WG'*G)\(WG'*tbin);
         B=W*G;
         y=W*tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
         
         A.cdom.constant(n,m)=mm(1);
         A.cdom.sin(n,m,:)=mm(2:maxharmonic+1);
         A.cdom.cos(n,m,:)=mm(maxharmonic+2:end);
      end
   end
   kk=~isnan(bb(n,:));  % now bb
   tlev=bb(n,kk)';
   timelev=time(kk);
   distlev=dist(kk);
   for m=1:nbin
      jj=((distlev >= (xcenter(m)-search(m))) & (distlev < (xcenter(m)+search(m))));
      timebin=timelev(jj);
      tbin=tlev(jj);
      ind=find(isnan(timebin));
      timebin(ind)=[];
      tbin(ind)=[];
      
      num=length(tbin);
      
      if num >= 1+2*maxharmonic
         W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
         G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
         %WG=W*G;
         %mm=(WG'*G)\(WG'*tbin);
         B=W*G;
         y=W*tbin;
         [U,Si,V]=svd(B);
         mm=(V*pinv(Si)*U')*y;
         
         A.bb.constant(n,m)=mm(1);
         A.bb.sin(n,m,:)=mm(2:maxharmonic+1);
         A.bb.cos(n,m,:)=mm(maxharmonic+2:end);
      end
   end

   
end

% finally, u and v
% get data between yearstart and yearend
% dv=datevec(ut2dn(ctd.timeu));
% ii=dv(:,1) >= yearstart & dv(:,1) <= yearend;
% time=2*pi*ctd.timeu(ii)/86400/365.25;
% dist=ctd.distu(ii);
% u=ctd.u(ii);
% v=ctd.v(ii);
% 
% kk=~isnan(u);
% ulev=u(kk);
% vlev=v(kk);
% timelev=time(kk);
% distlev=dist(kk);
% for m=1:nbin
%    jj=distlev >= xcenter(m)-search(m) & distlev < xcenter(m)+search(m);
%    timebin=timelev(jj);
%    ubin=ulev(jj);
%    vbin=vlev(jj);
%    num=length(ubin);
%    
%    if num >= 1+2*maxharmonic
%       W=spdiags(exp(-((distlev(jj)-xcenter(m))/xwidth(m)).^2),0,num,num);
%       G=[ones(num,1) sin(timebin*(1:maxharmonic)) cos(timebin*(1:maxharmonic))];
%       WG=W*G;
%       mm=(WG'*G)\(WG'*ubin);
%       
%       A.u.constant(m)=mm(1);
%       A.u.sin(m,:)=mm(2:maxharmonic+1);
%       A.u.cos(m,:)=mm(maxharmonic+2:end);
%       
%       mm=(WG'*G)\(WG'*vbin);
%       
%       A.v.constant(m)=mm(1);
%       A.v.sin(m,:)=mm(2:maxharmonic+1);
%       A.v.cos(m,:)=mm(maxharmonic+2:end);
%    end
% end
